---
title: "ssh keys for git"
layout: lab
tags: 
- R
- Git
- Linux
hidden: yes
---

Tired of having to enter your password every time you push or pull from git?

Want to use git from within RStudio?

__There is a solution__

We will use an [ssh public key](https://help.ubuntu.com/community/SSH/OpenSSH/Keys) to authenticate your identity.

In this method of authentication you generate a public key and a private key.  The private key stays on your computer (in this case your AWS instance) and the public key is given to 3rd parties who will want to verify your identity (in this case GitHub).

When you attempt to login to GitHub a program called [SSH](https://help.ubuntu.com/community/SSH) tests to see if your computer has the matching private key.

## Generate a ssh key pair

You can either generate a ssh key pair at the command line or in Rstudio.  For this class, we will use Rstudio.

1. Open Rstudio on your instance.
2. Choose `Tools > Global options` from the pull-down menu.
3. From the options box, click on `Git/Svn` on the left hand tab side
![]({{site.baseurl}}/images/RstudioOptionsPane.png)
4. Click `Create RSA Key...`
![]({{site.baseurl}}/images/RstudioSSHpane.png)
5. I usually don't create a passphrase, but for extra security feel free to.
6. Click `Create`
7. Click `Close`
![]({{site.baseurl}}/images/RstudioSSHsuccess.png)
8. Click `View public key`
![]({{site.baseurl}}/images/RstudioSSHsuccess2.png)
9. Press ctrl+c to copy the key to your clipboard. 

## Add your public key to github

Go to github.com and login to your account

Click on the your profile icon near the upper right hand side and then select `settings`.

![]({{site.baseurl}}/images/GitHub_SSH1.png)

Click on `SSH keys` on the left hand side

Paste in your key and press `add key`

### Test the connection

    ssh -T git@github.com

You may get a warning.  Go ahead and type `yes`.  You should then get a message that you have successfully authenticated.

![]({{site.baseurl}}/images/GitHub_SSH2.png)

## Update repository settings on your computer

In order to use the public key / private key authentication you must change the URL for your repository so that it uses ssh instead of https.

Go to GitHub for your repository, find the URL for cloning.  Click below it to change the access method to ssh and then copy the URL.

![]({{site.baseurl}}/images/GitHub_SSH3.png)

In the Linux terminal cd to the directory for that repository and update the URL

    cd ~/Assignment_3_Julin.Maloof/
    git remote set-url origin PASTE_IN_CLIPBOARD_URL_HERE


Now you should be all set!

Use the SSH URL method for cloning future repositories









