coding-test2-api
================

## REST API

### Restricted

| Resource | Description|
| ------------- |:-----|
| GET tests     | Get the list of all the tests |
| GET tests/:id | Get a test|
| PUT tests/:id | Create/update a test      |
| DELETE tests/:id | Delete a test |
| GET sessions | Get the list of sessions |
| POST sessions | Create a session |
| DELETE sessions/:id | Delete a session |

### Public

| Resource | Description|
| ------------- |:-----|
| GET sessions/:id | Get a session. |
| POST sessions/:id | Start a session |
| GET sessions/:id/:time | Get the test code |
| PUT sessions/:id/:time | Finish a session |
| PUT answers/:id | Update answers. Put an empty answer to start a test. |
| GET answers/:id | Get an answer. |
