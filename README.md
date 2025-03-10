# Forza data tools

This tool is a fork of [https://github.com/richstokes/Forza-data-tools](https://github.com/richstokes/Forza-data-tools). It was updated to allow for docker deployment as well as Azure Event Hub integration.

The tool was built with [golang](https://golang.org/dl/) for collecting the UDP data provided by modern Forza games.

[**Example Output**](./dash/sample.json)

## Features
- Realtime telemetry output to Azure Event Hub and terminal  
- Telemetry data logging to csv file  
- Serve Forza Telemetry data as JSON over HTTP
- Display race statistics from race/drive (when logging to CSV)
- Docker deployment method

## Usage

### Docker

This tool can be run in a docker container, requiring at minimum a valid Azure Event Hub connection string.

**Simple Run Example**

`docker run -e EVENTHUB_CONNECTION_STRING="Endpoint://YourEventHubConnectionStringwithNamespaceAndSharedAccessKeyHere" -p 8080:8080 -p 9999:9999/udp ghcr.io/cbattlegear/forza-data-tools:latest`

#### Environment Variables

| Feature                | Description                                      | Default Value | Required | Format |
|------------------------|--------------------------------------------------|---------------|----------|--------|
| `EVENTHUB_CONNECTION_STRING` | Full string to Azure Event Hub             | None          | True     | "Endpoint=sb://..." |
| `FDT_QUIET`            | Suppresses most output to Docker                 | false         | False    | true |
| `FDT_DEBUG`            | Enables verbose output, basically screams json   | false         | False    | true |
| `FDT_USERNAME`         | Provides username value in the json output       | "none"        | False    | FreeFormString |

#### Networking

| Port | Description | Extra |
|------|-------------|-------|
| `9999/udp` | Telemetry capture port | |
| `8080/tcp` | JSON server output port. | By default this is enabled but does not need to be mapped if not desired to be exposed.

### Binary

The application can be ran on baremetal but this fork was intended to be ran in docker with the inclusion of Azure Event Hub. This functionality is maintained but not recommended.

#### Build
Compile the application with: `go build -o fdt`  

#### Run

Run the application with `fdt` and providing the appropriate flags for desired behavior.

**Command line options**

| Flag | Description | Extra |
|------|-------------|-------|
| `-c /path/to/log.csv` | Output to csv file | If exists, will be overwritten |
| `-z`  | Enable Forza Horizon support ||
| `-j`  | Enable JSON Server | JSON data available at [http://localhost:8080/forza](http://localhost:8080/forza) |
| `-q`  | Disable realtime terminal output ||
| `-d`  | Enable debug information  ||

**Example for Forza Motorsport, outputting to CSV and enabling JSON server**

`fdt -c -j log.csv`  

#### JSON Data
If the `-j` flag is provided, JSON data will be available at: http://localhost:8080/forza. Could be used to make a web dashboard interface or something similar. JSON Format is an array of objects containing the various Forza data types.  

You can see a sample of the kind of data that will be returned [here](https://github.com/richstokes/Forza-data-tools/blob/master/dash/sample.json).  

There is a basic example JavaScript dashboard (with rev limiter function) in the `/dash` directory.  

### Forza Configuration

From your game settings, navigate to the HUD options, enable the data out feature and set it to use the IP address of your computer. Port 9999.  

If playing Forza Motorsport, select the "car dash" format.

More information and setup of this feature available [here](https://support.forzamotorsport.net/hc/en-us/articles/21742934024211-Forza-Motorsport-Data-Out-Documentation)
