require "aws-sdk"

def handler(event:, context:)
  dynamodb = Aws::DynamoDB::Client.new
  table_name = ENV["TABLE_NAME"] # get the table name from the automatically populated environment variables

  begin
    # Use dynamodb to get items from the ItemTable
    result = dynamodb.scan({
      table_name: table_name, 
    })
    result_count = result[:scanned_count]

    for item in result[:items] do
      item_id = item["id"]
      content = item["content"]
      puts "Item #{item_id}: #{content}"
    end

  rescue  Aws::DynamoDB::Errors::ServiceError => error # stop execution if dynamodb is not available
    puts "Error fetching table #{table_name}. Make sure this function is running in the same environment as the table."
    puts "#{error.message}"
  end

  # Return a 200 response if no errors
  response = {
    "statusCode": 200,
    "body": "#{result_count} items found"
  }

  return response
end
