# Staff Scheduler
## Requirement
    docker v24.0.3
    docker-compose v2.19.1
## Running
    docker-compose up
## Endpoints
- POST http://127.0.0.1:3003/api/v1/signup
    -   This is the entry point for a user
    -   payload:
       {
            "user": {
                "name": "{name}",
                "email": "{email}",
                "password": "{password}"
                }
        }
    - Response:
        - statuscode: 200
            - message: "User created successfully"
        - statuscode: 422,400
            - error:<appropoiate message is shown>
- POST http://127.0.0.1:3003/api/v1/login
    -   This is the login api, returns jwt
    -   The token received through this api is required in header as a Bearer token for every further api to uthenticate and authorize a user
    -   payload:
       {
                "email": "{email}",
                "password": "{password}"
        }
    - Response:
        - statuscode: 200
            - token: "{jwt}"
        - statuscode: 401
            - error:<unauthorized error>
- POST http://localhost:3003/api/v1/schedules (permission: admin)
    -   This is the create schedule api
    -   headers
        -   Authorization:Bearer <jwt>
        -   Content-Type: application/json
    -   payload:
       {
              "workdate": "2023-07-12",
              "user_id": 14,
              "shift_length_hours": 2
        }
    - Response:
        - statuscode: 201
            - {
    "id": <this is schedule id>
    "workdate":,
    "shift_length_hours": ,
    "user_id":,
    "created_at":,
    "updated_at":"
}
        - statuscode: 401, 422
            - error:<unauthorized error/unprocessable entity> 
- PATCH http://localhost:3000/api/v1/schedules/{schedule_id} (permission: admin)
    -   This is the update schedule api
    -   headers
        -   Authorization:Bearer <jwt>
        -   Content-Type: application/json
    -   payload:
{
  "workdate": "2023-07-12",
  "user_id": 8,
  "shift_length_hours": 2
}

    - Response:
        - statuscode: 201
            - {
                "id":
                "workdate":,
                "shift_length_hours": ,
                "user_id":,
                "created_at":,
                "updated_at":"
}
        - statuscode: 401, 422
            - error:<unauthorized error/unprocessable entity> 
- DELETE http://localhost:3003/api/v1/schedules/{schedule_id} (permission: admin)
    -   This is the delete schedule api
    -   headers
        -   Authorization:Bearer <jwt>
        -   Content-Type: application/json
    - Response:
        - statuscode: 200
            - {
                "message": "Schedule deleted"
}
        - statuscode: 401, 422
            - error:<unauthorized error/unprocessable entity> 
- PATCH http://localhost:3003/api/v1/users/{user_id} (permission: admin)
    -   This is the update user api
    -   headers
        -   Authorization:Bearer <jwt>
        -   Content-Type: application/json
    - payload
        {
  "user": {
    "name":,
    "email":,
    "password":
  }
}
    - Response:
        - statuscode: 200
            - {"email":,"password_digest":,"id":,"role":,"name","created_at":,"updated_at":}
        - statuscode: 401, 422
            - error:<unauthorized error/unprocessable entity> 
- DELETE http://localhost:3003/api/v1/users/{user_id} (permission: admin)
    -   This is the delete user api
    -   headers
        -   Authorization:Bearer <jwt>
        -   Content-Type: application/json
    - Response: 
        - statuscode: 200
            - {
                "message": "User deleted"
}
        - statuscode: 401, 422
            - error:<unauthorized error/unprocessable entity> 
- POST http://localhost:3003/api/v1/promote (permission: admin)
    -   This is the promote user api, this api promotes a user to admin
    -   headers
        -   Authorization:Bearer <jwt>
        -   Content-Type: application/json
    - payload
        {
  "id":
}
    - Response:
        - statuscode: 200
            - {"message: User has been promoted to admin."}
        - statuscode: 401, 422
            - error:<unauthorized error/id is required>
- POST http://localhost:3003/api/v1/schedules/order_by_accumulated_hours (permission: admin)
    -   This api order users by their accumulated hours in certain period
    -   headers
        -   Authorization:Bearer <jwt>
        -   Content-Type: application/json
    - payload
        {
  "start_date":,
  "end_date":
}
    - Response: 
        - statuscode: 200
            - [19, 1, 16, 4]
        - statuscode: 401, 422
            - error:<unauthorized error> 
- POST http://localhost:3003/api/v1/schedules/get_schedule (permission: all)
    -   This api gives schedule of any user between a time period
    -   headers
        -   Authorization:Bearer <jwt>
        -   Content-Type: application/json
    - payload
        {
    "user_id":,
    "start_date",
    "end_date":
}
    - Response:
        - statuscode: 200
            - [
    {
        "id": 3,
        "work_date":,
        "shift_length_hours":,
        "user_id":,
        "created_at":,
        "updated_at":
    },
    {
        "id": 4,
        "work_date":,
        "shift_length_hours":,
        "user_id":,
        "created_at":,
        "updated_at":
    }
]
        - statuscode: 400, 422
            - error:<unauthorized error/invalid request>

## Features
-   Authentication and Authorization has been done using JWT
-   Two roles has been set(staff: 0 and admin: 1)
-   Exposes the port 3003 which accepts the API get the requests.

## Working
-   Launches 2 docker containers
    -   db :
        -   Container for mysql. exposes 3306 port can be connected using host:127.0.0.1, port:3306.
        -   Creates a database iv_db and there are two relevant tables in it(users and          schedules)
    -   app:
        -  Container where the application is running.
        -  Exposes 3003 port for the API connection.
-  User starts his journey from signup and receives a jwt from login api that he can use for    all the further apis.
-  A staff user can only be promoted to admin by an admin user, and then use admin apis
-  DB used for this purpose was MYSQL, as we have a structured data.

## Model
- User
    - has name, email, password and role
    - has many schedules
- Schedule
    - has shift_length_hours, work_date
    - belongs to user

## Troubleshooting
- Change the sleeptime in docker-entrypoint.sh file in case of unable to connect to mysql error