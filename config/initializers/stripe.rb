Rails.configuration.stripe = {
    :publishable_key => 'pk_test_bTXjdoNyXnGbsmNC0HSCHC9r',
    :secret_key => 'sk_test_c99Ms4WEX14mebtkwLWacAdX'
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]