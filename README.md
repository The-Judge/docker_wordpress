# About this image

This is a 1:1 clone of the upstream base image [wordpress:latest].  
The only difference is that a hook is added to allow for executing ([sourcing](https://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x237.html)
in fact) arbitrary shell scripts before any service is started. This way,
it is easy to make small changes like creating directories, applying
permissions or (de-)activate/(un-)install PHP modules without re-building
the whole image.

## How to use this image?

All the documents provided by [wordpress:latest] apply without any
exception for this image, as well.  
Additionally to this, it is possible to [source](https://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x237.html) a shell script (executed
without spawning a sub-shell) before any of the main service elements
is started. This works in the following way:

Everything that is written to a shell script located at `/mnt/extra/hook.sh`
is executed. There is no need to care for file permissions; as long as
the root user can read it (which is the case pretty much always), the
execution works as well.  
**Attention:** Take care that your script does not exit or execute with an
error, since then it might prevent the processing to actually start the
main services which happens after this hook-script execution!

As long as you do not need this additional executions, you may use this
image as a drop-in replacement of the original [wordpress:latest] image
since nothing is different compared to it in this case.  
As soon as you need an additional command or even larger script being
executed, you can either extend this image (or the [wordpress:latest] one)
with a brief `Dockerfile` like this:

    FROM derjudge/wordpress
    RUN whatever-voodoo-comes-to-your-mind ...

followed by a `docker build -t <your-tag> .` or do it like this, eliminating
the need to rebuild (and deploy) the image:

    mkdir /tmp/somewhere
    cp /path/to/your/script.sh /tmp/somewhere/hook.sh
    docker run -v /tmp/somewhere:/mnt/extra -d derjudge/wordpress

That's it! Your script can contain anything that suits a shell script,
really. Even serve as a executioner for other interpreters like Python,
if `hook.sh` is something like this:

    apt update
    apt install -y python3
    python3 /mnt/extra/my_python_script.py

## When to not use this image or the hook?

You can always use this image instead of [wordpress:latest], since no
impediment is known.  
On the other hand, when changes introduced by your hook script are quite
much or you are executing something that takes a vast amount of time or
utilizes other resources (like a huge download not only takes some time 
but also utilizes your bandwidth), it might make sense to include that
in an extended image instead (as shown before).  
But even under that circumstances, this image can be used instead of the
base one and is even recommended, since this way there is no space needed
to store and update several Docker images, locally.

## How recent is this image?

This image uses Docker Hub's autobuild mechanism. That means, that
whenever the upstream image at [wordpress:latest] is updated or there is
any update in this image's Git repository, a new build of this image will
be triggered, automatically.  
That way, this image is ensured to be as recent as the upstream base
image, which is maintained by a strong and active community, always.

[wordpress:latest]: https://hub.docker.com/_/wordpress

