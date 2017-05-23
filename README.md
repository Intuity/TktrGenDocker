# TktrGen Docker

## Introduction

TktrGen is a NodeJS package for generating PDF tickets from HTML templates with support for QR or Aztec codes. It is designed to work with ticket data exports from the Tktr ticketing system.

TktrGen has a number of prerequisites (WKHTMLToPDF, PDFTK, NodeJS, etc.) - to make it easier to setup, a Dockerfile is provided that creates the required environment and provides an easy command to generate tickets.

## Setup

A number of setup stages are required to install TktrGen within Docker.

### Install Docker
You may skip this section if you have already installed Docker. These instructions are a summarised version of https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04

1. Update the package database:
   ```bash
   sudo apt-get update
   ```
2. Add the Docker repository and GPG keys:
   ```bash
   sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
   sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
   ```
3. Update the package database to pickup the changes:
   ```bash
   sudo apt-get update
   ```
4. Now install Docker using Aptitude:
   ```bash
   sudo apt-get install -y docker-engine
   ```
5. To avoid typing 'sudo' at the start of every instruction add yourself to the Docker group:
   ```bash
   sudo usermod -aG docker $(whoami)
   ```

### Grabbing and Building the Dockerfile
To install the TktrGen Docker image, use the Dockerfile.

1. Clone the GitHub repository:
   ```bash
   cd ~
   git clone https://github.com/Intuity/TktrGenDocker
   ```
2. Build the Docker image:
   ```bash
   cd ~/TktrGenDocker
   docker build -t tktr/tktrgen .
   ```

The second step will take some time to complete as it has to build out a base Ubuntu image and install all of the additional dependencies.

## Using the Docker Image
The Docker image will, by default, run an interactive version of TktrGen that takes a few items of input to configure the tool and then generates all of the required tickets. The commands below link the output directory of the Docker image to a local folder in your home area. This folder is where you should place the source CSV file and where all of the generated tickets will be placed.

1. Create a folder in your home area to use as a target for ticket generation:
   ```bash
   mkdir -p ~/TktrGenOutput
   ```
2. Place your source data CSV file (e.g. tickets.csv) into the newly created directory:
   ```bash
   cp tickets.csv ~/TktrGenOutput/tickets.csv
   ```
3. Execute the run Docker command to start the interactive tool:
   ```bash
   docker run --rm -ti -v ~/TktrGenOutput:/usr/src/TktrGen/TktrGen/output tktr/tktrgen
   ```
4. You will see the following prompts, either accept the defaults by pressing 'enter' or type in your preferred option:
   ```bash
   [TktrGen :: PDF Ticket Generation from HTML Templates]

   This tool offers an interactive console for generating
   PDF tickets from HTML templates. The tool will now ask
   a number of questions to configure the templating
   process. To accept the default option, just press enter
   without entering any other text.

   Do you want to generate digital or printed tickets? (default: digital)
   # Enter either 'digital' or 'printed' here
   What output directory to you want to use? (default: output)
   # Just accept the default by pressing 'enter'
   Which CSV file do you want to use as a source of data? (default: tickets.csv)
   # Enter the name of the source CSV file you copied into the TktrGenOutput directory in step 2
   ```

The tickets should now be generated and will appear in the 'TktrGenOutput' directory created in step 1.
