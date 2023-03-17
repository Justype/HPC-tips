Below is the archive and too complex.

> OR
> 
> 1. Comment out the key after connecting using semicolon `;`
> 2. Reconnect to the server
> 3. Repeat 1 and 2 until you get the keys for all the login nodes
> 4. Remove duplicate keys
> 5. Add `log#` in front of the keys (Just make sure the hostname is DIFFERENT. Whether it corresponds or not is not important)
> 
> For NYU greene, just copy this to your `~/.ssh/known_hosts` (working not well on 2/22/2023)
>
> ```
> ; NYU Greene
> greene.hpc.nyu.edu ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPXeQKa1foaijDEZx4qF0+DPgt6Zj3M2bqxsU0SYtvFL0pGhq1ZHW4b88l5nI2zLAw0H+CaU3j8WDq04uZZQW8lzRLUeQwNsT5baqDwcdIdG2RtRxjTHpttkB9JODZ4p3pPVhuEfZKiSdlzjnhpd1lpTFw5i/GrBswRqM1TcgaZnWP+iAeltaRX1jcbEQwfhlCe/nTRbVemR6P1MR6Tl//gi6m64Y3vgrsc5aaPQh7Nb68Ahv+GXUlB6cTvTNp/loZ3lB8NHotPzzipaHtZX9X2x0ZsSYAu3YUNXPxFJmpmYpsUwBtik/oYVzDBrDWMelYGZymCMvkUluuoiXqgiTLhz/4yz7y32W+nWaxDUJ/TH1ng2OfA6asnYzfk8s5UYrQ83VE02yAxGe1XuuN2y4tQInXtu1fGKkSN+VKhwFzVAzEzJTMKDthzJ7oHFdQ1lxc7qgLvThFzg7pkAgeZdvu/tiGsdbcUIqYsEzf/5ePyTx2sjpVRCd1CVC+KaFTj4s=
> greene.hpc.nyu.edu ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBDTHjuZNZhwswGP5BghtaS3VV/gI0BRvH9fDuWViIJD2VTiwo4CqARI5r6kNmEnYX0jD6XO0ta6csJR8OBKkq3Q=
> 
> log1.greene.hpc.nyu.edu ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVsHesY6wT8mgxyJ3B6e7OD/8v92Mc3p76EnNtX0SsU
> log2.greene.hpc.nyu.edu ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOO1r0g8AZ9CKvBpfmZDrIvU6vr4shg60UCG90dCRD0y
> log3.greene.hpc.nyu.edu ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBeEkL/sU86PJHQnqCb7tLjfzqBo0eqT2L6bGVs8givZ
> ```

And after maintenance, the key will change.
