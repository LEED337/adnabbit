/**
 * AdNabbit Stripe Client Service
 * Handles frontend Stripe integration and backend communication
 */

class StripeClient {
    constructor() {
        // Replace with your actual Stripe publishable key
        this.stripe = Stripe('pk_test_51OExample123456789012345678901234567890123456789012345678901234567890');
        this.elements = this.stripe.elements();
        this.cardElement = null;
        
        // Backend API base URL - update for production
        this.apiBaseUrl = window.location.hostname === 'localhost' 
            ? 'http://localhost:3001/api'
            : 'https://your-backend-domain.com/api';
    }

    /**
     * Initialize Stripe Elements
     */
    initializeElements(containerId = 'card-element') {
        this.cardElement = this.elements.create('card', {
            style: {
                base: {
                    fontSize: '16px',
                    color: '#424770',
                    fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
                    '::placeholder': {
                        color: '#aab7c4',
                    },
                },
                invalid: {
                    color: '#dc2626',
                    iconColor: '#dc2626'
                }
            },
        });

        this.cardElement.mount(`#${containerId}`);
        return this.cardElement;
    }

    /**
     * Create payment method
     */
    async createPaymentMethod(billingDetails) {
        try {
            const {error, paymentMethod} = await this.stripe.createPaymentMethod({
                type: 'card',
                card: this.cardElement,
                billing_details: billingDetails,
            });

            if (error) {
                throw error;
            }

            return paymentMethod;
        } catch (error) {
            console.error('Payment method creation error:', error);
            throw error;
        }
    }

    /**
     * Create subscription
     */
    async createSubscription(subscriptionData) {
        try {
            const response = await fetch(`${this.apiBaseUrl}/create-subscription`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(subscriptionData)
            });

            const result = await response.json();
            
            if (!result.success) {
                throw new Error(result.error || 'Failed to create subscription');
            }

            return result;
        } catch (error) {
            console.error('Subscription creation error:', error);
            throw error;
        }
    }

    /**
     * Get subscription details
     */
    async getSubscription(subscriptionId) {
        try {
            const response = await fetch(`${this.apiBaseUrl}/subscription/${subscriptionId}`);
            const result = await response.json();
            
            if (!result.success) {
                throw new Error(result.error || 'Failed to retrieve subscription');
            }

            return result.subscription;
        } catch (error) {
            console.error('Subscription retrieval error:', error);
            throw error;
        }
    }

    /**
     * Update subscription (upgrade/downgrade)
     */
    async updateSubscription(subscriptionId, newPlan) {
        try {
            const response = await fetch(`${this.apiBaseUrl}/update-subscription`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    subscriptionId: subscriptionId,
                    newPlan: newPlan
                })
            });

            const result = await response.json();
            
            if (!result.success) {
                throw new Error(result.error || 'Failed to update subscription');
            }

            return result;
        } catch (error) {
            console.error('Subscription update error:', error);
            throw error;
        }
    }

    /**
     * Cancel subscription
     */
    async cancelSubscription(subscriptionId) {
        try {
            const response = await fetch(`${this.apiBaseUrl}/cancel-subscription`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    subscriptionId: subscriptionId
                })
            });

            const result = await response.json();
            
            if (!result.success) {
                throw new Error(result.error || 'Failed to cancel subscription');
            }

            return result;
        } catch (error) {
            console.error('Subscription cancellation error:', error);
            throw error;
        }
    }

    /**
     * Handle card element changes (validation)
     */
    onCardChange(callback) {
        if (this.cardElement) {
            this.cardElement.on('change', callback);
        }
    }

    /**
     * Confirm payment if 3D Secure is required
     */
    async confirmPayment(clientSecret, paymentMethod) {
        try {
            const {error, paymentIntent} = await this.stripe.confirmCardPayment(
                clientSecret,
                {
                    payment_method: paymentMethod.id
                }
            );

            if (error) {
                throw error;
            }

            return paymentIntent;
        } catch (error) {
            console.error('Payment confirmation error:', error);
            throw error;
        }
    }

    /**
     * Format currency for display
     */
    formatCurrency(amount, currency = 'USD') {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: currency,
        }).format(amount / 100);
    }

    /**
     * Validate card element
     */
    async validateCard() {
        if (!this.cardElement) {
            throw new Error('Card element not initialized');
        }

        // This will trigger validation
        const {error} = await this.stripe.createPaymentMethod({
            type: 'card',
            card: this.cardElement,
        });

        return !error;
    }
}

// Export for use in other scripts
window.StripeClient = StripeClient;