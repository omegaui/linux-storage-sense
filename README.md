
<div align="center">
    <img src="images/icon.png"/>
    <h3>written with ♥️ in <a href="https://vlang.io" target="_blank">V lang</a></h3>
</div>

# Linux Storage Sense

Linux Storage Sense is a lightweight and efficient command line program designed for Linux operating systems.
Its main function is to help users manage their storage space by automatically deleting files at specified paths
after a specified period of time.

## ![](https://img.icons8.com/external-basicons-color-danil-polshin/50/null/external-space-space-basicons-color-danil-polshin-16.png) Features

- Auto Deletes files at specified paths after a specified period of time
- Lightweight and efficient, with minimal CPU and memory usage
- Highly customizable, with options to specify paths and time periods (_even weeks, months and years are supported_)

## ![](https://img.icons8.com/external-flat-icons-pause-08/50/null/external-fuel-car-repair-flat-icons-pause-08-2.png) Resource Usage

Linux Storage Sense is designed to use minimal CPU and memory resources. 
The program is written using efficient algorithms and data structures,
minimizing the use of system calls and disk I/O, and optimizing the code for the Linux operating system. 
This allows it to run in the background without impacting other processes or causing slowdowns on the system.

**Finely tested on Ubuntu 22.10**

## ![](https://img.icons8.com/external-flatart-icons-flat-flatarticons/50/null/external-design-design-thinking-flatart-icons-flat-flatarticons.png) Architecture

The program has two parts.
- **Storage Sense Configurator**: Used for adding and remove watchdogs.
- **Storage Sense Daemon**: Auto starts on system login and cleans storage according to the configurations provided.


To use Linux Storage Sense, users must specify the paths of the files they want to manage and the period of time after which they want these files to be deleted. 
Then, the daemon process will automatically identify and delete the appropriate files.

## ![](https://img.icons8.com/external-flaticons-flat-flat-icons/50/null/external-manual-design-flaticons-flat-flat-icons.png) Example

### Listing Active Watchdogs

```sh
$ storage-sense-config
```

### Adding Files/Directories

```sh
$ storage-sense-config --add="temp.txt:images"
```

### Removing Files/Directories

```sh
$ storage-sense-config --remove="temp.txt:images"
```

the add flag, furher asks for the time peroid and time unit,
here's an example run:
```sh
omegaui@asus:~$ storage-sense-config --add="/home/omegaui/VS Code Projects/linux-storage-sense/update-config.sh"
Validating Paths ...
- /home/omegaui/VS Code Projects/linux-storage-sense/update-config.sh ✔️
1 valid path(s), 0 invalid path(s)
time period can be in seconds, minutes, days, weeks, months or even years
example: 12 seconds, 20 days, etc
Enter time period: 190 seconds
Adding NEW Watchdog: /home/omegaui/VS Code Projects/linux-storage-sense/update-config.sh
 ---> Saving Configuration [0 ms]
 ---> Adding Watchdogs [7642 ms]
```

## ![](https://img.icons8.com/fluency/48/null/goal.png) Usability 

### General Purpose

Linux Storage Sense is an ideal choice for users who want to automate file cleanup tasks on their Linux systems without causing performance issues or slowing down other processes.
Its lightweight and efficient design, along with its customizability, make it a valuable tool for managing storage space on Linux systems.

### Development Purpose

Programmers who want to delete raw files generated by their program over time, during testing or debugging,
can use **storage-sense** to automate the task as it also supports **seconds** as time unit.

# ![](https://img.icons8.com/dusk/50/null/linux.png) Install

**Linux One Liner Install Command**

```shell
curl https://raw.githubusercontent.com/omegaui/linux-storage-sense/main/install.sh | sh
```

**NOTE: Time calculations are based on the system up time and not the realtime date**