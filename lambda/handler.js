const AWS = require("aws-sdk");
const dynamo = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = process.env.TABLE_NAME;

module.exports.handler = async (event) => {
  try {
    const code = event.pathParameters && event.pathParameters.code;
    
    if (!code) {
      return {
        statusCode: 400,
        headers: { 
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*"
        },
        body: JSON.stringify({ message: "Falta parámetro 'code'" })
      };
    }

    const getResult = await dynamo.get({
      TableName: TABLE_NAME,
      Key: { code: code }
    }).promise();

    if (!getResult.Item) {
      return {
        statusCode: 404,
        headers: { 
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*"
        },
        body: JSON.stringify({ message: "Código no encontrado" })
      };
    }

    const now = new Date();
    const timestamp = now.toISOString();
    const date = now.toISOString().split('T')[0]; // YYYY-MM-DD
    
    try {
      const newEntry = [timestamp];

      await dynamo.update({
        TableName: TABLE_NAME,
        Key: { code: code },
        UpdateExpression: "SET visits = if_not_exists(visits, :zero) + :inc, lastVisit = :timestamp, visit_history = list_append(if_not_exists(visit_history, :empty_list), :newEntry)",
        ExpressionAttributeValues: {
          ":inc": 1,
          ":zero": 0,
          ":timestamp": timestamp,
          ":newEntry": newEntry, 
          ":empty_list": []  
        }
      }).promise();
      
      console.log(`Visita registrada para código: ${code} en fecha: ${date}`);
    } catch (updateErr) {
      console.error("Error actualizando visitas:", updateErr);
    }

    return {
      statusCode: 302,
      headers: {
        Location: getResult.Item.originalUrl,
        "Access-Control-Allow-Origin": "*"
      }
    };

  } catch (err) {
    console.error("Error:", err);
    return {
      statusCode: 500,
      headers: { 
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
      body: JSON.stringify({ 
        message: "Error interno", 
        details: err.message || err 
      })
    };
  }
};