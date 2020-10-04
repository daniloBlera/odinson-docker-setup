<!-- For you reading the raw contents of this file, hello :) -->
# About the installation
These steps below were based on the official documentation, here: http://gh.lum.ai/odinson/docker.html

The script `install.sh` will execute the steps below but the data directory tree will be created under the current directory to avoid cluttering your user's `HOME`.

# Notes
In order to query the odinson system, you must first preprocess the data in two steps:

*   Annotation
*   Indexing

For simplicity, we'll be using the provided *docker* for both preprocessing and querying so install docker on your system and start its daemon before the next steps.

# 1. Downloading the Docker Images
To download the preprocessing and the query images, run

```zsh
docker pull lumai/odinson-extras:latest
docker pull lumai/odinson-rest-api:latest
```

# 2. Organizing the Text Data
You'll have to create the directory structure for text annotation and indexing. For this tutorial we'll be placing the data under `$HOME/data/odinson`. If you want to avoid cluttering your user's `HOME` you can change this directory accordingly.

First, create the directory to hold the raw texts running

```zsh
mkdir -p "$HOME/data/odinson/text"
```

Now, copy the raw texts into the above directory. The `BB-Rel` dataset from *BioNLP OST 2019* can be found here:

*   https://github.com/daniloBlera/brat-server-setup/tree/master/datasets/bb-rel

Download and extract the *dev* dataset, then copy any of the `.txt` files into `$HOME/data/odinson/text`, for example, extract the file `BB-rel-10496597.txt` from the *dev* dataset into `$HOME/data/odinson/text/BB-rel-10496597.txt`.

Finally, in order to allow the docker image to write to the host directories under `$HOME/data/odinson`, change its permissions with

```zsh
chmod -R 777 "$HOME/data/odinson"
```

# 3. Annotating Documents
To annotate all text documents under `$HOME/data/odinson/text`, run

```zsh
docker run \
    --name="odinson-extras" \
    -it \
    --rm \
    -e "HOME=/app" \
    -e "JAVA_OPTS=-Dodinson.extra.processorType=CluProcessor" \
    -v "$HOME/data/odinson:/app/data/odinson" \
    --entrypoint "bin/annotate-text" \
    "lumai/odinson-extras:latest"
```

The annotation process will create a `.json.gz` under `$HOME/data/odinson/docs` for each text document under `$HOME/data/odinson/text`.

obs.1: If you used a different path to the data, configure the correct path on the `-v` option, note that it must be an **absolute path** to the directory containing the `text` directory (which contains the raw text documents).

obs.2: For easier reproduction, consider adding the docker commands from this guide in separate script files.

obs.3: You can open the (extracted) json file on a browser such as Firefox to see the `key: value` structure of the annotated file.

# 4. Indexing Documents
After generating the text annotations, proceed to index the files running:

```zsh
docker run \
    --name="odinson-extras" \
    -it \
    --rm \
    -e "HOME=/app" \
    -v "$HOME/data/odinson:/app/data/odinson" \
    --entrypoint "bin/index-documents" \
    "lumai/odinson-extras:latest"
  ```

The indexing process will create some data under `$HOME/data/odinson/index`.

# 5. Running Queries
After indexing the annotated documents, start the RESTful query image (locally) with

```zsh
docker run \
    --name="odinson-rest-api" \
    -it \
    --rm \
    -e "HOME=/app" \
    -p "0.0.0.0:9001:9000" \
    -v "$HOME/data/odinson:/app/data/odinson" \
    "lumai/odinson-rest-api:latest"
```

If the container is running properly you can access the API from a browser on http://localhost:9001.

obs.: The official documentation on the queries syntax can be found under http://gh.lum.ai/odinson/queries.html
