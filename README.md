# Art

Elixir application for representing ASCII art drawing canvas.

## Installation

1. Install Elixir with `1.12` version
2. Install PostgreSQL
3. Run `cp .env.example .env` in the terminal and replace variables in the `.env` with real values.
4. Run `mix deps.get`
5. Run `source .env && mix ecto.create`
6. Run `source .env && mix ecto.migrate`

## How to run the application

Start the server with `source .env && iex -S mix`

## How to run tests

Run `source .env && mix test`

## Instructions for interaction with application

### Available endpoints:

#### Web:

- GET http://localhost:4000/canvases – is used for displaying all existing canvases

#### Api:

- POST http://localhost:4000/canvases – is used for new canvas creation. It requires a canvas size and a file with instructions as parameters.

Example of request: 

`curl -v -F 'canvas[width]=32' -F 'canvas[height]=12' -F file=@test/fixtures/canvases/rectangles_with_flood_fill_1.txt localhost:4000/api/canvases`


- PATCH http://localhost:4000/canvases/<id> – is used for updating existing canvas. It requires an existing canvas' id, a new canvas size and a file with instructions as parameters.


Example of request:

`curl --request PATCH -v -F 'canvas[width]=5' -F 'canvas[height]=5' -F file=@test/fixtures/canvases/rectangles_2.txt localhost:4000/api/canvases/8`
