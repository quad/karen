meta 'luks' do
  template {
    def device
      `blkid -t PARTLABEL=luks`.split(':').first
    end
  }
end

dep 'open.luks', :disk do
  def keyfile
    'keyfile.passphrase'
  end

  requires 'passphrase.luks'.with(keyfile)
  requires 'format.luks'.with(disk, keyfile)

  met? { '/dev/mapper/luks'.p.exists? }
  meet { shell "cryptsetup --batch-mode --key-file='#{keyfile}' luksOpen #{device} luks" }
end

dep 'format.luks', :disk, :keyfile do
  requires 'luks.partition'.with(disk)

  met? { shell? "cryptsetup isLuks #{device}" }
  meet { shell! "cryptsetup --batch-mode luksFormat #{device} #{keyfile}" }
end

dep 'passphrase.luks', :filename do
  met? { filename.p.exists? }
  meet { filename.p.write tell_passphrase }
end
