Rails.configuration.stripe = {
    :publishable_key => 'pk_live_xXF7tZQOM1U6teMOSQQP9fjB',
    :secret_key => 'sk_live_2C0xKdMOfFkEYhnA3gaQut0G'
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]