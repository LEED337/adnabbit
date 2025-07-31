# AdNabbit Stripe Backend Service

This backend service handles Stripe payment processing for AdNabbit subscriptions.

## Features

- ✅ **Subscription Management** - Create, update, and cancel subscriptions
- ✅ **Customer Management** - Handle customer creation and updates
- ✅ **Webhook Processing** - Handle Stripe webhook events
- ✅ **Plan Management** - Support for Basic, Standard, and Premium plans
- ✅ **Payment Method Handling** - Secure payment method attachment
- ✅ **Proration Support** - Handle plan upgrades/downgrades with prorations

## Setup Instructions

### 1. Install Dependencies
```bash
cd backend
npm install
```

### 2. Configure Environment Variables
```bash
cp .env.example .env
```

Edit `.env` file with your actual Stripe credentials:
```env
STRIPE_SECRET_KEY=sk_test_your_actual_secret_key
STRIPE_PUBLISHABLE_KEY=pk_test_your_actual_publishable_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret
```

### 3. Create Stripe Products and Prices

In your Stripe Dashboard, create:

**Products:**
- AdNabbit Basic Plan
- AdNabbit Standard Plan  
- AdNabbit Premium Plan

**Prices (Monthly Recurring):**
- Basic: $150/month → `price_basic_monthly_id`
- Standard: $200/month → `price_standard_monthly_id`
- Premium: $300/month → `price_premium_monthly_id`

Update the Price IDs in your `.env` file.

### 4. Set Up Webhooks

In Stripe Dashboard:
1. Go to Developers → Webhooks
2. Add endpoint: `https://your-domain.com/api/webhook`
3. Select events:
   - `customer.subscription.created`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`
   - `invoice.payment_succeeded`
   - `invoice.payment_failed`
4. Copy webhook secret to `.env`

### 5. Start the Service

**Development:**
```bash
npm run dev
```

**Production:**
```bash
npm start
```

## API Endpoints

### POST `/api/create-subscription`
Create a new subscription
```json
{
  "paymentMethodId": "pm_1234567890",
  "customerEmail": "user@example.com",
  "customerName": "John Doe",
  "plan": "standard"
}
```

### GET `/api/subscription/:subscriptionId`
Get subscription details

### POST `/api/update-subscription`
Update subscription plan
```json
{
  "subscriptionId": "sub_1234567890",
  "newPlan": "premium"
}
```

### POST `/api/cancel-subscription`
Cancel subscription
```json
{
  "subscriptionId": "sub_1234567890"
}
```

### POST `/api/webhook`
Stripe webhook handler (raw body required)

## Frontend Integration

Include the Stripe client service:
```html
<script src="js/stripe-client.js"></script>
```

Initialize and use:
```javascript
const stripeClient = new StripeClient();
const cardElement = stripeClient.initializeElements();

// Create subscription
const paymentMethod = await stripeClient.createPaymentMethod({
  name: 'John Doe',
  email: 'john@example.com'
});

const subscription = await stripeClient.createSubscription({
  paymentMethodId: paymentMethod.id,
  customerEmail: 'john@example.com',
  customerName: 'John Doe',
  plan: 'standard'
});
```

## Security Considerations

- ✅ **Environment Variables** - Never commit secrets to version control
- ✅ **HTTPS Only** - Use HTTPS in production
- ✅ **Webhook Verification** - Always verify webhook signatures
- ✅ **Input Validation** - Validate all incoming data
- ✅ **CORS Configuration** - Restrict origins in production

## Deployment

### Heroku
```bash
heroku create adnabbit-stripe-backend
heroku config:set STRIPE_SECRET_KEY=sk_live_your_key
heroku config:set STRIPE_WEBHOOK_SECRET=whsec_your_secret
git push heroku main
```

### Vercel
```bash
vercel --prod
```

### AWS Lambda
Use the Serverless framework or AWS SAM for deployment.

## Testing

Use Stripe's test cards:
- **Success:** 4242424242424242
- **Decline:** 4000000000000002
- **3D Secure:** 4000002500003155

## Support

For issues with this backend service, check:
1. Stripe Dashboard logs
2. Server logs
3. Webhook event logs
4. Network connectivity

## License

MIT License - see LICENSE file for details.