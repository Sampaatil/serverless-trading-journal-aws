
const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const {
  DynamoDBDocumentClient,
  DeleteCommand
} = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({});
const dynamo = DynamoDBDocumentClient.from(client);

const TABLE_NAME = process.env.TABLE_NAME;

const response = (statusCode, body) => ({
  statusCode,
  headers: {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "*",
    "Access-Control-Allow-Methods": "GET,POST,PUT,DELETE,OPTIONS"
  },
  body: JSON.stringify(body)
});

exports.handler = async (event) => {

  console.log("===== EVENT =====");
console.log(JSON.stringify(event, null, 2));

console.log("===== HEADERS =====");
console.log(event.headers);

console.log("===== REQUEST CONTEXT =====");
console.log(event.requestContext);

console.log("===== AUTHORIZER =====");
console.log(event.requestContext?.authorizer);

console.log("===== CLAIMS =====");
console.log(event.requestContext?.authorizer?.claims);

console.log("===== JWT =====");
console.log(event.requestContext?.authorizer?.jwt);


  console.log("EVENT:", JSON.stringify(event, null, 2));

  try {

    const claims = event.requestContext?.authorizer?.claims;

    if (!claims) {
      return response(401, {
        message: "Unauthorized"
      });
    }

    const userId = claims.sub;

    const body = JSON.parse(event.body);

    if (!body.tradeId) {
      return response(400, {
        message: "tradeId is required"
      });
    }

    await dynamo.send(
      new DeleteCommand({

        TableName: TABLE_NAME,

        Key: {
          userId,
          tradeId: body.tradeId
        }

      })
    );

    return response(200, {
      message: "Trade deleted successfully"
    });

  }

  catch (err) {

    console.error(err);

    return response(500, {
      message: "Internal Server Error",
      error: err.message
    });

  }

};