---
layout: post
title: Solving Virtual Box Problems on Windows
---

Some people have received errors on windows machines "VT-x is not available. (VERR_VMX_NO_VMX)".

Several students have solved this as follows (thanks Mai):

1. You will need to access your BIOS system.  The exact method depends on the manufacturer of your laptop.  You can search online for "How to access BIOS" and include your computer make/model in the search.  Regardless of method ou will need to restart you computer and then use the access button.  For example:
    1. On Lenovo there is a button to access to BIOS configuration system.
    2. On HP, you can press F10 right away after you press 'power on' button, and then you will get a prompt asking if you want access to BIOS system.
2. Once you have access to BIOS: Go to Setting -> BIOS configuration -> Intel Virtual Technology -> Enable
then Save and Exit.

If you have additional information please email Prof. Maloof and he will update this post.
