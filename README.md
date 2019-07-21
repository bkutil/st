# st

Computes summary statistics from the command line.

For every input line, a line is printed to standard output, with comma
separated current statistics values. It follows this format:

```
    position   statistic
    1          last
    2          count
    3          sum
    4          mean
    5          std
    6          min
    7          max
    8          q10
    9          q25
    10         q50
    11         q75
    12         q90
    13         q99
```

This can be then parsed using `cut`.

For quantile estimation, `st` samples the input using naive Reservoir
sampling algorithm, to save memory. The sample size is pre-set to 1024.

## Installation

```shell
curl https://raw.githubusercontent.com/bkutil/st/master/st > /usr/local/bin/st
chmod 755 /usr/local/bin/st
```

## Usage

```
for i in $(seq 1 1 1000); do echo $RANDOM; done | st
14745,1,14745.0,14745.0,0.0,14745.0,14745.0,14745.0,14745.0,14745.0,14745.0,14745.0,14745.0
8368,2,23113.0,11556.5,10166532.25,8368.0,14745.0,8368.0,8368.0,14745.0,14745.0,14745.0,14745.0
...
23877,998,16464042.0,16497.03607214426,87113616.36944029,14.0,32734.0,3606.0,8439.0,16411.0,24511.0,29010.0,32536.0
4603,999,16468645.0,16485.130130130103,87167883.50458767,14.0,32734.0,3606.0,8431.0,16387.0,24511.0,29010.0,32536.0
1017,1000,16469662.0,16469.66199999997,87319739.407756,14.0,32734.0,3606.0,8431.0,16387.0,24511.0,29010.0,32536.0
```

## Contributing

Bug reports, comments, and patches are welcome. If anything doesn't seem right or could be improved,
feel free to open an issue, or send me an email - balazs@kutilovi.cz.

## License

`st` is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
