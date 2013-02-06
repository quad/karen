meta 'luks' do
  template {
    def luks_map
      '/dev/mapper/luks'
    end

    def device
      '/dev/disk/by-partlabel/luks'
    end
  }
end

dep 'format.luks', :disk do
  def keyfile
    'keyfile.passphrase'
  end

  def cryptsetup command, options={}
    opt_args = options.map { |k, v| "--#{k}='#{v}'" }.join ' '

    shell! "cryptsetup --batch-mode #{opt_args} #{command}"
  end

  requires 'luks.partition'.with(disk)
  requires 'passphrase.luks'.with(keyfile)

  met? { 
    cryptsetup "luksClose luks" if luks_map.p.exists?
    cryptsetup "luksOpen #{device} luks", 'key-file' => keyfile
  }
  meet { cryptsetup "luksFormat #{device} #{keyfile}" }
end

dep 'passphrase.luks', :filename do
  met? { filename.p.exists? }
  meet { filename.p.write tell_passphrase }
end
