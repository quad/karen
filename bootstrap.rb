dep 'bootstrap', :disk do
  disk.default! '/dev/sda'

  requires 'stage1.bootstrap'.with(disk)

  # TODO: What's a better way of doing this?
  met? { shell? "arch-chroot /mnt babushka --dry-run #{dependency.dep_source.name}:stage1" }
  meet {
    log_shell 'babushka: stage1...',
              "arch-chroot /mnt babushka #{dependency.dep_source.name}:stage1"
  }
end

dep 'stage1.bootstrap', :disk do
  requires 'babushka.bootstrap'.with(disk)

  met? { '/mnt/root/.babushka/sources/karen/.git'.p.dir? }
  meet {
    log_shell "Downloading #{dependency.dep_source.name} deps...",
	      "arch-chroot /mnt babushka sources --add #{dependency.dep_source.name} #{dependency.dep_source.uri}"
  }
end

dep 'babushka.bootstrap', :disk do
  requires 'chroot.bootstrap'.with(disk)

  met? { '/mnt/usr/local/babushka'.p.dir? }
  meet {
    log_shell 'Installing babushka...',
              'arch-chroot /mnt sh -c "`curl https://babushka.me/up`"'
  }
end

dep 'chroot.bootstrap', :disk do
  requires 'mounts.bootstrap'.with(disk)

  met? { shell? "arch-chroot /mnt true" }
  meet { log_shell 'Bootstrapping Arch Linux...', 'pacstrap /mnt base base-devel' }
end

dep 'filesystems.bootstrap', :disk do
  requires 'boot.fs'.with(disk)
  requires 'swap.fs'.with(disk)
  requires 'root.fs'.with(disk)
end

dep 'mounts.bootstrap', :disk do
  requires 'filesystems.bootstrap'.with(disk)

  requires 'root.mnt'.with(disk)
  requires 'boot.mnt'.with(disk)
  requires 'swap.mnt'.with(disk)
end
