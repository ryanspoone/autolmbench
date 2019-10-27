Automated LMBench
============

This harness performs LMBench memory bandwidth and latency benchmarking.

Download and Run
----------------

To download these files, first install git:

```bash
yum install git
```

Or if you are using a Debian-based distribution:

```bash
apt-get install git
```

Clone this repository:

```bash
git clone https://github.com/ryanspoone/autolmbench.git
```

Change directories and run this script:

```bash
cd autolmbench/
chmod +x autolmbench
./autolmbench
```

Usage
-----

Change to directory where files are, then start benchmarking by issuing the following command:

For a full run:

```bash
./autolmbench
```

Customized run:

```bash
./autolmbench [OPTIONS...]
```

Where the options are:

| Option     | GNU long option      | Meaning                                |
|------------|----------------------|----------------------------------------|
| -h         | --help               | Show this message.                     |
| -p         | --prerequisites      | Install prerequisites.                 |
| -t [n]     | --threads [n]        | Override the number of threads to use. |
| -i [value] | --iterations [value] | Set the number of iterations.          |
