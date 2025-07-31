/**
 * AdNabbit Stripe Payment Backend Service
 * Handles subscription creation, management, and webhooks
 */

const express = require('express');
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
const cors = require('cors');
const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Plan configurations with your actual product and price IDs
const PLANS = {
    basic: {
        name: 'Basic Plan',
        price: 15000, // $150.00 in cents
        screens: 10,
        productId: 'prod_SmM5PN69uNah4f',
        priceId: process.env.STRIPE_PRICE_BASIC || 'price_1RqnNGLmvO6Fl5tLfMBqACWI'
    },
    standard: {
        name: 'Standard Plan',
        price: 20000, // $200.00 in cents
        screens: 15,
        productId: 'prod_SmM5CHmp3dRMaD',
        priceId: process.env.STRIPE_PRICE_STANDARD || 'price_1RqnNeLmvO6Fl5tLoTcNTNe5'
    },
    premium: {
        name: 'Premium Plan',
        price: 30000, // $300.00 in cents
        screens: 30,
        productId: 'prod_SmM6d8dDSi1h6B',
        priceId: process.env.STRIPE_PRICE_PREMIUM || 'price_1RqnNtLmvO6Fl5tLeOcb6VK3'
    }
};

/**
 * Create a new subscription
 */
app.post('/api/create-subscription', async (req, res) => {
    try {
        const { paymentMethodId, customerEmail, customerName, plan } = req.body;
        
        if (!PLANS[plan]) {
            return res.status(400).json({ error: 'Invalid plan selected' });
        }

        const selectedPlan = PLANS[plan];

        // Create or retrieve customer
        let customer;
        const existingCustomers = await stripe.customers.list({
            email: customerEmail,
            limit: 1
        });

        if (existingCustomers.data.length > 0) {
            customer = existingCustomers.data[0];
        } else {
            customer = await stripe.customers.create({
                email: customerEmail,
                name: customerName,
                metadata: {
                    plan: plan,
                    source: 'adnabbit_registration'
                }
            });
        }

        // Attach payment method to customer
        await stripe.paymentMethods.attach(paymentMethodId, {
            customer: customer.id,
        });

        // Set as default payment method
        await stripe.customers.update(customer.id, {
            invoice_settings: {
                default_payment_method: paymentMethodId,
            },
        });

        // Create subscription
        const subscription = await stripe.subscriptions.create({
            customer: customer.id,
            items: [{
                price: selectedPlan.priceId,
            }],
            default_payment_method: paymentMethodId,
            expand: ['latest_invoice.payment_intent'],
            metadata: {
                plan: plan,
                screens_limit: selectedPlan.screens.toString()
            }
        });

        res.json({
            success: true,
            subscriptionId: subscription.id,
            customerId: customer.id,
            status: subscription.status,
            clientSecret: subscription.latest_invoice.payment_intent.client_secret
        });

    } catch (error) {
        console.error('Subscription creation error:', error);
        res.status(400).json({ 
            success: false, 
            error: error.message 
        });
    }
});

/**
 * Get subscription details
 */
app.get('/api/subscription/:subscriptionId', async (req, res) => {
    try {
        const { subscriptionId } = req.params;
        
        const subscription = await stripe.subscriptions.retrieve(subscriptionId, {
            expand: ['customer', 'items.data.price']
        });

        res.json({
            success: true,
            subscription: {
                id: subscription.id,
                status: subscription.status,
                current_period_start: subscription.current_period_start,
                current_period_end: subscription.current_period_end,
                plan: subscription.metadata.plan,
                amount: subscription.items.data[0].price.unit_amount,
                customer: {
                    id: subscription.customer.id,
                    email: subscription.customer.email,
                    name: subscription.customer.name
                }
            }
        });

    } catch (error) {
        console.error('Subscription retrieval error:', error);
        res.status(400).json({ 
            success: false, 
            error: error.message 
        });
    }
});

/**
 * Update subscription (upgrade/downgrade)
 */
app.post('/api/update-subscription', async (req, res) => {
    try {
        const { subscriptionId, newPlan } = req.body;
        
        if (!PLANS[newPlan]) {
            return res.status(400).json({ error: 'Invalid plan selected' });
        }

        const subscription = await stripe.subscriptions.retrieve(subscriptionId);
        
        const updatedSubscription = await stripe.subscriptions.update(subscriptionId, {
            items: [{
                id: subscription.items.data[0].id,
                price: PLANS[newPlan].priceId,
            }],
            metadata: {
                plan: newPlan,
                screens_limit: PLANS[newPlan].screens.toString()
            },
            proration_behavior: 'create_prorations'
        });

        res.json({
            success: true,
            subscription: updatedSubscription
        });

    } catch (error) {
        console.error('Subscription update error:', error);
        res.status(400).json({ 
            success: false, 
            error: error.message 
        });
    }
});

/**
 * Cancel subscription
 */
app.post('/api/cancel-subscription', async (req, res) => {
    try {
        const { subscriptionId } = req.body;
        
        const subscription = await stripe.subscriptions.update(subscriptionId, {
            cancel_at_period_end: true
        });

        res.json({
            success: true,
            subscription: subscription
        });

    } catch (error) {
        console.error('Subscription cancellation error:', error);
        res.status(400).json({ 
            success: false, 
            error: error.message 
        });
    }
});

/**
 * Stripe webhook handler
 */
app.post('/api/webhook', express.raw({type: 'application/json'}), (req, res) => {
    const sig = req.headers['stripe-signature'];
    let event;

    try {
        event = stripe.webhooks.constructEvent(req.body, sig, process.env.STRIPE_WEBHOOK_SECRET);
    } catch (err) {
        console.error('Webhook signature verification failed:', err.message);
        return res.status(400).send(`Webhook Error: ${err.message}`);
    }

    // Handle the event
    switch (event.type) {
        case 'customer.subscription.created':
            console.log('Subscription created:', event.data.object.id);
            // Handle successful subscription creation
            break;
        
        case 'customer.subscription.updated':
            console.log('Subscription updated:', event.data.object.id);
            // Handle subscription changes
            break;
        
        case 'customer.subscription.deleted':
            console.log('Subscription cancelled:', event.data.object.id);
            // Handle subscription cancellation
            break;
        
        case 'invoice.payment_succeeded':
            console.log('Payment succeeded:', event.data.object.id);
            // Handle successful payment
            break;
        
        case 'invoice.payment_failed':
            console.log('Payment failed:', event.data.object.id);
            // Handle failed payment
            break;
        
        default:
            console.log(`Unhandled event type ${event.type}`);
    }

    res.json({received: true});
});

/**
 * Health check endpoint
 */
app.get('/api/health', (req, res) => {
    res.json({ 
        status: 'healthy', 
        service: 'adnabbit-stripe-service',
        timestamp: new Date().toISOString()
    });
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
    console.log(`AdNabbit Stripe service running on port ${PORT}`);
});

module.exports = app;