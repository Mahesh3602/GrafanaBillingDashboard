resource "aws_api_gateway_rest_api" "MyDemoAPI" {
  name        = "MyDemoAPI"
  description = "This is my API for demonstration purposes"
  
   endpoint_configuration {
    types = ["REGIONAL"]
  }

}

resource "aws_api_gateway_resource" "MyDemoResource" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  parent_id   = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  path_part   = "mydemoresource"
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.MyDemoResource.id
  http_method   = "PUT"
  authorization = "NONE"
  api_key_required = true
  operation_name = "aws_api_gateway_deployment.example.invoke_url"
}

resource "aws_api_gateway_integration" "MyDemoIntegration" {
  rest_api_id          = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id          = aws_api_gateway_resource.MyDemoResource.id
  http_method          = aws_api_gateway_method.MyDemoMethod.http_method
  type                 = "AWS"
  #cache_key_parameters = ["method.request.path.param"]
  #cache_namespace      = "foobar"
  #timeout_milliseconds = 29000
  integration_http_method = "PUT"
  uri = aws_lambda_function.copy_lambda.invoke_arn
  
}


resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = "200"

  depends_on = [
    aws_api_gateway_integration.MyDemoIntegration
  ]
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  # Transforms the backend JSON response to XML
  depends_on = [
    aws_api_gateway_integration.MyDemoIntegration
  ]
}


resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  stage_name = "example"

  depends_on = [
    aws_api_gateway_integration.MyDemoIntegration
  ]
}


resource "aws_lambda_permission" "apigw" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.copy_lambda.function_name
  principal = "apigateway.amazonaws.com"

}

resource "aws_api_gateway_usage_plan" "example" {
  name         = "my-usage-plan"
  

  api_stages {
    api_id = aws_api_gateway_rest_api.MyDemoAPI.id
    stage  = aws_api_gateway_deployment.example.stage_name
  }
}
  resource "aws_api_gateway_api_key" "MyDemoApiKey" {
  name = "demo"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.MyDemoApiKey.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.example.id
}

output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}