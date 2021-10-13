<?php
/**
 * Entry point for the lambda function
 *
 * @param   array   $data
 * @return  string
 */
function process($data)
{
    if (isset($data['body'])) {
        if (isset($data['isBase64Encoded']) && $data['isBase64Encoded'] === true) {
            $data['body'] = base64_decode($data['body']);
        }

        $data = json_decode($data['body'], true);
    }

    if (!isset($data['name']))
    {
        return http_response(array(
            'error' => 'A name is required.'
        ), 400);
    }

    return http_response(array(
        'greeting' => 'Hello, ' . $data['name'],
        'time' => date('Y-m-d H:i:s')
    ), 200);
}

/**
 * Returns HTTP response
 *
 * @param   array   $body
 * @param   int     $status_code
 * @return  array
 */
function http_response($body, $status_code)
{
    return json_encode(array(
        'isBase64Encoded' => false,
        'statusCode' => $status_code,
        'headers' => array(
            'Content-Type' => 'application/json'
        ),
        'body' => json_encode($body)
    ));
}
