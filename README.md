coding-test2-api
================

## REST API

| Resource | Description|
| ------------- |:-----|
| GET tests     | Get the list of all the tests |
| GET tests/:id | Get a test|
| PUT tests/:id | Create/update a test      |
| DELETE tests/:id | Delete a test |
| GET sessions | Get the list of sessions |
| POST sessions | Create a session |
| DELETE sessions/:id | Delete a session |
| GET run/sessions/:id | Get test code. You need to PUT first to start the test |
| PUT run/sessions/:id | Start a test |
| PUT run/answers/:id | Update answers. Put an empty answer to start a test. |
