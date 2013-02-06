meta 'luks' do
  template {
    def cryptsetup command, options={}
      opt_args = options.map { |k, v| "--#{k}='#{v}'" }.join ' '

      shell? "cryptsetup --batch-mode #{opt_args} #{command}"
    end
  }
end

dep 'open.luks', :disk do
  requires 'luks.partition'.with(disk)

  def keyfile
    'keyfile.passphrase'
  end

  requires 'passphrase.luks'.with(keyfile)

  def device
    '/dev/disk/by-partlabel/luks'
  end

  requires 'format.luks'.with(device, keyfile)

  def luks_map
    '/dev/mapper/luks'
  end

  met? { luks_map.p.exists? }
  meet { cryptsetup "luksOpen #{device} luks", 'key-file' => keyfile }
end

dep 'passphrase.luks', :filename do
  met? { filename.p.exists? }
  meet { filename.p.write tell_passphrase }
end

dep 'format.luks', :device, :keyfile do
  met? { cryptsetup "luksOpen --test-passphrase #{device} luks", 'key-file' => keyfile }
  meet { cryptsetup "luksFormat #{device} #{keyfile}" }
end
