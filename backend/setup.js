/**
 * AdNabbit Stripe Setup Script
 * Run this script to create products and prices in your Stripe account
 */

require('dotenv').config();
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

const PRODUCTS = [
    {
        name: 'AdNabbit Basic Plan',
        description: 'Up to 10 digital screens with basic analytics and email support',
        price: 15000, // $150.00 in cents
        screens: 10
    },
    {
        name: 'AdNabbit Standard Plan',
        description: 'Up to 15 digital screens with advanced analytics and priority support',
        price: 20000, // $200.00 in cents
        screens: 15
    },
    {
        name: 'AdNabbit Premium Plan',
        description: 'Up to 30 digital screens with premium analytics and phone support',
        price: 30000, // $300.00 in cents
        screens: 30
    }
];

async function createProducts() {
    console.log('🚀 Setting up AdNabbit products in Stripe...\n');
    
    try {
        for (const productData of PRODUCTS) {
            console.log(`Creating ${productData.name}...`);
            
            // Create product
            const product = await stripe.products.create({
                name: productData.name,
                description: productData.description,
                metadata: {
                    screens_limit: productData.screens.toString(),
                    service: 'adnabbit'
                }
            });
            
            // Create monthly recurring price
            const price = await stripe.prices.create({
                unit_amount: productData.price,
                currency: 'usd',
                recurring: {
                    interval: 'month'
                },
                product: product.id,
                metadata: {
                    plan_type: productData.name.toLowerCase().includes('basic') ? 'basic' : 
                              productData.name.toLowerCase().includes('standard') ? 'standard' : 'premium'
                }
            });
            
            console.log(`✅ Created ${productData.name}`);
            console.log(`   Product ID: ${product.id}`);
            console.log(`   Price ID: ${price.id}`);
            console.log(`   Amount: $${productData.price / 100}/month\n`);
        }
        
        console.log('🎉 All products created successfully!');
        console.log('\n📝 Next steps:');
        console.log('1. Copy the Price IDs above');
        console.log('2. Update your .env file with these Price IDs:');
        console.log('   STRIPE_PRICE_BASIC=price_xxx');
        console.log('   STRIPE_PRICE_STANDARD=price_xxx');
        console.log('   STRIPE_PRICE_PREMIUM=price_xxx');
        console.log('3. Update the stripe-service.js file with these Price IDs');
        console.log('4. Set up webhook endpoints in your Stripe Dashboard');
        
    } catch (error) {
        console.error('❌ Error creating products:', error.message);
        
        if (error.message.includes('No such API key')) {
            console.log('\n💡 Make sure you have set STRIPE_SECRET_KEY in your .env file');
        }
    }
}

async function listExistingProducts() {
    console.log('📋 Checking existing products...\n');
    
    try {
        const products = await stripe.products.list({ limit: 10 });
        const prices = await stripe.prices.list({ limit: 20 });
        
        if (products.data.length === 0) {
            console.log('No products found. Running setup...\n');
            return false;
        }
        
        console.log('Existing products:');
        for (const product of products.data) {
            const productPrices = prices.data.filter(p => p.product === product.id);
            console.log(`• ${product.name} (${product.id})`);
            for (const price of productPrices) {
                console.log(`  - $${price.unit_amount / 100}/${price.recurring?.interval} (${price.id})`);
            }
        }
        
        console.log('\n❓ Do you want to create AdNabbit products anyway? (y/N)');
        return true;
        
    } catch (error) {
        console.error('❌ Error listing products:', error.message);
        return false;
    }
}

// Main execution
async function main() {
    console.log('🏪 AdNabbit Stripe Setup\n');
    
    if (!process.env.STRIPE_SECRET_KEY) {
        console.error('❌ STRIPE_SECRET_KEY not found in environment variables');
        console.log('💡 Make sure you have a .env file with your Stripe secret key');
        process.exit(1);
    }
    
    const hasExisting = await listExistingProducts();
    
    if (!hasExisting) {
        await createProducts();
    } else {
        // In a real scenario, you might want to prompt the user
        console.log('\n⚠️  Products already exist. Skipping creation.');
        console.log('Run with --force flag to create anyway.');
    }
}

// Run if called directly
if (require.main === module) {
    main().catch(console.error);
}

module.exports = { createProducts, listExistingProducts };