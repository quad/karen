dep 'clear.partitions', :disk do
  disk.default! '/dev/sda'
  met? { shell? "sgdisk --zap-all #{disk}" }
end

meta 'partition' do
  accepts_value_for :block_device
  accepts_value_for :number
  accepts_value_for :size
  accepts_value_for :code
  accepts_list_for :attributes

  template {
    def sgdisk args
      shell! "sgdisk #{args} #{block_device}"
    end

    def label
      name.gsub /\.partition$/, ''
    end

    met? { shell? "blkid -t PARTLABEL=#{label}" }
    meet {
      sgdisk "--new=#{number}:0:#{size}"
      sgdisk "--typecode=#{number}:#{code}00"
      sgdisk "--change-name=#{number}:#{label}"
      attributes.each do |attr|
        sgdisk "--attributes=#{number}:set:#{attr}"
      end
    }
  }
end

dep 'boot.partition', :disk do
  block_device disk
  number 1
  size '+1G'
  code '83'
  attributes [2]
end

dep 'luks.partition', :disk do
  block_device disk
  number 2
  size '0'
  code '8e'
end
