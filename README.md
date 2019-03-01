# st

Computes summary statistics from the command line.

Count, sum, mean, standard deviation and approximate quantiles are supported.

For quantile estimation, `st` samples the input using naive Reservoir
sampling algorithm.

## Installation

```shell
wget https://git.kutilovi.cz/bkutil/st/raw/master/st -O /usr/local/bin/st
chmod 755 /usr/local/bin/st
```

## Usage

```
for i in $(seq 1 1 1000); do echo $RANDOM; done | st
...
...
26283
29737
21226
1289
7604
{
  "count": 1000,
  "sum": 16377308.0,
  "min": 34.0,
  "max": 32765.0,
  "mean": 16377.308000000014,
  "std": 87993555.95713618,
  "q": {
    "0.1": 3653.0,
    "0.25": 8075.0,
    "0.5": 16255.0,
    "0.75": 24549.0,
    "0.9": 29461.0,
    "0.99": 32438.0
  }
}
```

## Contributing

Bug reports, comments, and patches are welcome - feel free to send me an email - balazs@kutilovi.cz.

## License

`st` is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
