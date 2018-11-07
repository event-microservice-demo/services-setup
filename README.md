# Demo Setup

1. First user docker-compose to bring MongoDB, Kafka and Zookeeper up, and wait enough to make sure everything is running.

```
docker-compose up
```

2. Setup the MongoDB:

  * Open up http://localhost:8081
  * Create a new database called `testjobs`
  * Create 2 collections in `testjobs` called `jobs` and `companies`

3. Setup Kafka topics:

  * Using the `kafkahelper.sh` shell script, create 2 topics:

```
  ./kafkahelper.sh -t jobs
  ./kafkahelper.sh -t companies
```

  * You can check if the topics are created by using the following:

```
  ./kafkahelper.sh -l
```

4. Setup test data to send (as part of a demo for example). You can use something like Postman to call the API endpoints to send test data. These API endpoints are only created for demo purposes, normally the data should be fed by the services.

  * Use the following endpoint:

```
http://localhost:5001/send
```

  * For jobs: (in the body of request)

```json
{
	"topic" : "jobs",
	"message": {
		"urn": "urn:jobs:10002",
		"title": "Software Engineer I, ECommerce",
		"companyId": "urn:companies:1000",
		"location": {
			"city": "SF",
			"state": "CA",
			"country": "US"
		},
		"description": "Great job, come and join us!",
		"level": "Individual Contributor",
		"industry": "IT"
	}
}
```

  * For companies: (in the body of request)

```json
{
	"topic" : "companies",
	"message": {
		"urn": "urn:companies:1000",
		"name": "Google",
		"location": {
			"city": "SF",
			"state": "CA",
			"country": "US"
		},
		"description": "Good company"
	}
}
```

5. Start the services:

  * For the graph-ql service, use the [job-details repo](https://github.com/event-microservice-demo/job-details)
    * Clone it, then run `npm install`, followed by `npm start`

  * For the job/companies producer service, use the [job-producer repo](https://github.com/event-microservice-demo/job-producer)
    * Clone it, then run `npm install`, followed by `npm start`

  * For the job details consumer service, use the [job-details-consumer repo](https://github.com/event-microservice-demo/job-details-consumer)
    * Clone it, then run `npm install`, followed by `npm start`

6. Now you can send the demo messages (companies and jobs) as discussed in step 4. This will publish the messages to the corresponding topics in Kafka.

7. Check if the messages are saved in MongoDB (job-details-consumer service will read the messages and store in MongoDB)

  * Check [jobs collection](http://localhost:8081/db/testjobs/jobs)
  * Check [companies collection](http://localhost:8081/db/testjobs/companies)

8. Now you can check the graphql response, using the [GraphQL playground](http://localhost:4000/graphql):

```graphql
query JobDetails {
  jobByUrn (urn: "urn:jobs:10002") {
    title,
    urn
    industry,
    company {
      urn,
      name
    },
    location {
      city
    }
  }
}
```

which should return:

```json
{
  "data": {
    "jobByUrn": {
      "title": "Software Engineer I, ECommerce",
      "urn": "urn:jobs:10002",
      "industry": "IT",
      "company": {
        "urn": "urn:companies:1000",
        "name": "Google"
      },
      "location": {
        "city": "SF"
      }
    }
  }
}
```

# Tips

## Connecting to the MongoDB database

```

docker exec -it event-store-poc_mongo_1 mongo -u "root" -p "example" HOSTIP --authenticationDatabase "admin" mongo-setup.js

```