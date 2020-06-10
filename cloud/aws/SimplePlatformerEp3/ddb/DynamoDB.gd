extends Node

signal response(result, response_code, headers, body)

# ************* REQUEST VALUES *************
var method := 'POST'
var service := 'dynamodb'

# POST requests use a content type header. For DynamoDB,
# the content is JSON.
var content_type := 'application/x-amz-json-1.0'

# Key derivation functions. See:
# http://docs.aws.amazon.com/general/latest/gr/signature-v4-examples.html#signature-v4-examples-python
# https://github.com/summerplaygames/godot-hmac
func sign_hmac(key:PoolByteArray, msg:String) -> PoolByteArray:
	return $Hmac.digest(key, msg.to_utf8(), "sha256")


func getSignatureKey(key:String, date_stamp:String, regionName:String, serviceName:String) -> PoolByteArray:
	var kDate := sign_hmac(('AWS4' + key).to_utf8(), date_stamp)
	var kRegion := sign_hmac(kDate, regionName)
	var kService := sign_hmac(kRegion, serviceName)
	var kSigning := sign_hmac(kService, 'aws4_request')
	return kSigning

# Read AWS access key from env. variables or configuration file. Best practice is NOT
# to embed credentials in code.
# DynamoDB requires an x-amz-target header that has this format:
#     DynamoDB_<API version>.<operationName>
func call_dynamodb(access_key, secret_key, 
					json_request_parameters:Dictionary = {"ExclusiveStartTableName": "Thread", "Limit": 1}, 
					amz_target := 'DynamoDB_20120810.DescribeLimits', region := 'us-east-1'):
						
	var request_parameters = to_json(json_request_parameters)
	var host := 'dynamodb.' + region + '.amazonaws.com'
	var endpoint := 'https://dynamodb.' + region + '.amazonaws.com/'

	var datetime = OS.get_datetime(true)

	# Create a date for headers and the credential string
	var timeDict = OS.get_time();
	if String(datetime["month"]).length() == 1: datetime["month"] = "0"+String(datetime["month"])
	if String(datetime["day"]).length() == 1: datetime["day"] = "0"+String(datetime["day"])
	if String(datetime["hour"]).length() == 1: datetime["hour"] = "0"+String(datetime["hour"])
	if String(datetime["minute"]).length() == 1: datetime["minute"] = "0"+String(datetime["minute"])
	if String(datetime["second"]).length() == 1: datetime["second"] = "0"+String(datetime["second"])
	var amz_date = String(datetime["year"]) + String(datetime["month"]) + String(datetime["day"]) + "T" + String(datetime["hour"]) + String(datetime["minute"]) + String(datetime["second"]) + "Z"
	var date_stamp = String(datetime["year"]) + String(datetime["month"]) + String(datetime["day"])
	
	# ************* TASK 1: CREATE A CANONICAL REQUEST *************
	# http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
	
	# Step 1 is to define the verb (GET, POST, etc.)--already done.
	
	# Step 2: Create canonical URI--the part of the URI from domain to query
	# string (use '/' if no path)
	var canonical_uri = '/'
	
	## Step 3: Create the canonical query string. In this example, request
	# parameters are passed in the body of the request and the query string
	# is blank.
	var canonical_querystring = ''
	
	# Step 4: Create the canonical headers. Header names must be trimmed
	# and lowercase, and sorted in code point order from low to high.
	# Note that there is a trailing \n.
	var canonical_headers = 'content-type:' + content_type + '\n' + \
						'host:' + host + '\n' + \
						'x-amz-date:' + amz_date + '\n' + \
						'x-amz-target:' + amz_target + '\n'
	
	# Step 5: Create the list of signed headers. This lists the headers
	# in the canonical_headers list, delimited with ";" and in alpha order.
	# Note: The request can include any headers; canonical_headers and
	# signed_headers include those that you want to be included in the
	# hash of the request. "Host" and "x-amz-date" are always required.
	# For DynamoDB, content-type and x-amz-target are also required.
	var signed_headers = 'content-type;host;x-amz-date;x-amz-target'
	
	# Step 6: Create payload hash. In this example, the payload (body of
	# the request) contains the request parameters.
	var payload_hash = request_parameters.sha256_text()
	
	# Step 7: Combine elements to create canonical request
	var canonical_request = method + '\n' + \
						canonical_uri + '\n' + \
						canonical_querystring + '\n' + \
						canonical_headers + '\n' + \
						signed_headers + '\n' + \
						payload_hash
	
	
	# ************* TASK 2: CREATE THE STRING TO SIGN*************
	# Match the algorithm to the hashing algorithm you use, either SHA-1 or
	# SHA-256 (recommended)
	var algorithm = 'AWS4-HMAC-SHA256'
	var credential_scope = date_stamp + '/' + region + '/' + service + '/' + 'aws4_request'
	var string_to_sign = algorithm + '\n' +  amz_date + '\n' +  credential_scope + '\n' +  canonical_request.sha256_text()
	
	# ************* TASK 3: CALCULATE THE SIGNATURE *************
	# Create the signing key using the function defined above.
	var signing_key = getSignatureKey(secret_key, date_stamp, region, service)
	
	# Sign the string_to_sign using the signing_key
	var signature = $Hmac.hexdigest(signing_key, string_to_sign.to_utf8(), "sha256")


	# ************* TASK 4: ADD SIGNING INFORMATION TO THE REQUEST *************
	# Put the signature information in a header named Authorization.
	var authorization_header = algorithm + ' ' + \
		'Credential=' + access_key + '/' + credential_scope + ', ' +  \
		'SignedHeaders=' + signed_headers + ', ' + \
		'Signature=' + signature
	
	# For DynamoDB, the request can include any headers, but MUST include "host", "x-amz-date",
	# "x-amz-target", "content-type", and "Authorization". Except for the authorization
	# header, the headers must be included in the canonical_headers and signed_headers values, as
	# noted earlier. Order here is not significant.
	# # Python note: The 'host' header is added automatically by the Python 'requests' library.
	var headers = PoolStringArray(['Content-Type:'+content_type,
			   'X-Amz-Date:'+amz_date,
			   'X-Amz-Target:'+amz_target,
			   'Authorization:'+authorization_header])
	
	
	# ************* SEND THE REQUEST *************
	$HTTPRequest.request(endpoint, headers, true, 2, request_parameters)
	


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	emit_signal("response", result, response_code, headers, body.get_string_from_utf8())
