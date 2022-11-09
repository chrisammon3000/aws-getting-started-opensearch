# Getting started with Amazon OpenSearch Service

CloudFormation deployment following the AWS documentation tutorial for OpenSearch:
https://docs.aws.amazon.com/opensearch-service/latest/developerguide/gsg.html

## Quickstart
1. Create `.env` and add variables
2. Run `make deploy`
3. Load records using option 1 or option 2

## Environment Variables
Sensitive environment variables containing secrets like passwords and API keys must be exported to the environment first.

Create a `.env` file in the project root.
```bash
STAGE=dev
APP_NAME=opensearch-tutorial
AWS_REGION=us-east-1
IAM_USERNAME=<value> # set your AWS IAM username used to log into the console
MASTER_USER=admin
MASTER_PASSWORD="Pa55word!"
```

## Tutorial

### Step 1: Create an Amazon OpenSearch Service domain
Run the comand to deploy an OpenSearch instance using the CloudFormation template.
```bash
make deploy
```

### Step 2: Upload data to Amazon OpenSearch Service for indexing

Set credentials and domain (found in AWS OpenSearch console).
```bash
export MASTER_USER=admin
export MASTER_PASSWORD="Pa55word!"
export DOMAIN_ENDPOINT=<value>
```

#### Option 1: Upload a single document
```bash
curl -XPUT -u "$MASTER_USER:$MASTER_PASSWORD" "$DOMAIN_ENDPOINT/movies/_doc/1" \
    -d '{"director": "Burton, Tim", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Brosnan","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'
```

Response:
```json
{
  "_index": "movies",
  "_type": "_doc",
  "_id": "1",
  "_version": 1,
  "result": "created",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "_seq_no": 0,
  "_primary_term": 1
}
```

#### Option 2: Upload multiple documents
```bash
curl -XPOST \
    -u "$MASTER_USER:$MASTER_PASSWORD" "$DOMAIN_ENDPOINT/_bulk" \
    --data-binary @data/bulk_movies.json -H 'Content-Type: application/json'
```

Response:
```json
{
  "took": 57,
  "errors": false,
  "items": [
    {
      "index": {
        "_index": "movies",
        "_type": "_doc",
        "_id": "2",
        "_version": 1,
        "result": "created",
        "_shards": {
          "total": 2,
          "successful": 1,
          "failed": 0
        },
        "_seq_no": 0,
        "_primary_term": 1,
        "status": 201
      }
    },
    {
      "index": {
        "_index": "movies",
        "_type": "_doc",
        "_id": "3",
        "_version": 1,
        "result": "created",
        "_shards": {
          "total": 2,
          "successful": 1,
          "failed": 0
        },
        "_seq_no": 0,
        "_primary_term": 1,
        "status": 201
      }
    },
    {
      "index": {
        "_index": "movies",
        "_type": "_doc",
        "_id": "4",
        "_version": 1,
        "result": "created",
        "_shards": {
          "total": 2,
          "successful": 1,
          "failed": 0
        },
        "_seq_no": 0,
        "_primary_term": 1,
        "status": 201
      }
    }
  ]
}

```

### Step 3: Search documents in Amazon OpenSearch Service

#### Search documents from the command line

```bash
curl -XGET -u "$MASTER_USER:$MASTER_PASSWORD" "$DOMAIN_ENDPOINT/movies/_search?q=mars&pretty=true"
```

Response:
```json
{
  "took": 169,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "skipped": 0,
    "failed": 0
  },
  "hits": {
    "total": {
      "value": 1,
      "relation": "eq"
    },
    "max_score": 0.2876821,
    "hits": [
      {
        "_index": "movies",
        "_type": "_doc",
        "_id": "1",
        "_score": 0.2876821,
        "_source": {
          "director": "Burton, Tim",
          "genre": [
            "Comedy",
            "Sci-Fi"
          ],
          "year": 1996,
          "actor": [
            "Jack Nicholson",
            "Pierce Brosnan",
            "Sarah Jessica Parker"
          ],
          "title": "Mars Attacks!"
        }
      }
    ]
  }
}
```

#### Search documents using OpenSearch Dashboards

OpenSearch Dashboards is a popular open source visualization tool designed to work with OpenSearch. It provides a helpful user interface for you to search and monitor your indices.

**To search documents from an OpenSearch Service domain using Dashboards**
1. Navigate to the OpenSearch Dashboards URL for your domain. You can find the URL on the domain's dashboard in the OpenSearch Service console. The URL follows this format: `$DOMAIN_ENDPOINT/_dashboards/`
2. Log in using your primary user name and password.
3. To use Dashboards, you need to create at least one index pattern. Dashboards uses these patterns to identify which indexes you want to analyze. Open the left navigation panel, choose Stack Management, choose Index Patterns, and then choose Create index pattern. For this tutorial, enter movies.
4. Choose Next step and then choose Create index pattern. After the pattern is created, you can view the various document fields such as actor and director.
5. Go back to the Index Patterns page and make sure that movies is set as the default. If it's not, select the pattern and choose the star icon to make it the default.
6. To begin searching your data, open the left navigation panel again and choose Discover.
7. In the search bar, enter mars if you uploaded a single document, or rebel if you uploaded multiple documents, and then press Enter. You can try searching other terms, such as actor or director names.

### Step 4: Delete an Amazon OpenSearch Service domain

Run the command to delete the CloudFormation stack.
```bash
make delete
```

## Troubleshooting
* Check your AWS credentials in `~/.aws/credentials`
* Check that the environment variables are available to the services that need them

## References & Links
- [Getting started with Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/gsg.html)

## Authors
**Primary Contact:** Gregory Lindsey ([@abk7777](https://github.com/abk7777))