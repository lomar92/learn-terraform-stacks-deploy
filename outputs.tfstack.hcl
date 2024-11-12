output "lambda_urls" {
  type = list(string)
  description = "URLs to invoke lambda functions"
  value = component.api_gatewayv2_stage.lambda.invoke_url
}
