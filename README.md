# Elevio Article Viewer

[![Build Status](https://travis-ci.org/aaneto/elevio-article-viewer.svg?branch=master)](https://travis-ci.org/aaneto/elevio-article-viewer)

The Elevio Article Viewer is a CLI tool for visualizing articles using the Elevio API.

currently, this means viewing articles by:
1. Paginating all articles on your account
2. Searching all articles by keyword
3. Viewing single articles with more information by id

Those three use cases are supported on this tool, if you have valid Authentication.

## Authentication
To run this application, you will need a TOKEN and a API_KEY, both can be generated for your account by logging into elevio, opening the Setup menu and selecting API Keys.

There you can generate a new API_KEY and TOKEN, a read-only key should suffice.

## Running with Docker
If you don't want to install elixir or mix you can use a docker image to run the application, to do this, open a terminal on the repository folder and run:

```bash
docker build . -t elevio

export API_KEY=YOUR_API_KEY
export TOKEN=YOUR_TOKEN

# Display article with ID 1
docker run -e API_KEY=$API_KEY -e TOKEN=$TOKEN -it elevio --id 1

# Paginate articles with keyword 'other' and language 'en'
docker run -e API_KEY=$API_KEY -e TOKEN=$TOKEN -it elevio --keyword other --language en

# Paginate all articles
docker run -e API_KEY=$API_KEY -e TOKEN=$TOKEN -it elevio --all
```

## Running in your machine

First, you should have mix and elixir installed on your machine and on your path, after that open a terminal in the repository folder and run:

```bash
mix deps.get
# You should have a 'elevio' binary on the working directory after this command
mix escript.build

export API_KEY=YOUR_API_KEY
export TOKEN=YOUR_TOKEN

# Display article with ID 1
./elevio --id 1

# Paginate articles with keyword 'other' and language 'en'
./elevio --keyword other --language en

# Paginate all articles
./elevio --all

# You can optionally install the script, note that you need to
# put mix escripts on PATH to run this anywhere.
mix escript.install
```

