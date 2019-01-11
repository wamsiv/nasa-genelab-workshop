# Workshop-Genelab

Container information:
| Name | Use | Dockerfile location |
| --- | --- | --- |
| `mapd/ml` | Demo notebooks | Dockerfile in top-level of `mapd-ml-demo` repo |

## Build

To build the `nasa-genelab-workshop` container, clone the repo and `cd` into it.

To build the container, run:

    docker build -t workshop-genelab .

### Exporting

If you need to move the containers to a new machine, run:

    docker save -o workshop-genelab.tar workshop-genelab

    gzip workshop-genelab.tar

You will then have files which can be moved to the new machine: `workshop-genelab.tar.gz`.

## Run

If running for the first time, make sure you have [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) installed and run it first. 

	
    nvidia-docker run -it nvidia/cuda nvidia-smi


If you have not signed up for [OmniSci Cloud](https://www.omnisci.com/cloud/), signup for the trial version to get API access to OmniSci core instance in order to run your notebooks. Once signed up, change the connection parameters in your notebook to the following:

	username = '<API KEY>'
	password = '<SECRECT KEY>'
	hostname = 'use2-api.omnisci.cloud'
	port = 443
	protocol = 'https'

Finally,

	nvidia-docker run --ipc=host -p 8888:8888 -it workshop-genelab

If you would like to use a volume, add `-v` flag. For example:

	-v notebooks:/dli/data/workshop-genelab/notebooks

Navigate to:
	
	http://localhost:8888
