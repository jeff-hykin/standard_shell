## Non-login new shell

```
IF ~/.bashrc exists THEN
    execute ~/.bashrc
END IF
```

## New Shell
```
execute /etc/profile
IF ~/.bash_profile exists THEN
    execute ~/.bash_profile
ELSE
    IF ~/.bash_login exist THEN
        execute ~/.bash_login
    ELSE
        IF ~/.profile exist THEN
            execute ~/.profile
        END IF
    END IF
END IF
```

## Logout
```
IF ~/.bash_logout exists THEN
    execute ~/.bash_logout
END IF
```

