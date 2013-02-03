require 'securerandom'

def word wordlist
  num = 5.times.map { SecureRandom.random_number(6) + 1 }.join
  wordlist.grep(/^#{num}/).first.split.last
end

def generate_passphrase
  diceware_path = File.expand_path '../beale.wordlist.asc', __FILE__
  diceware = File.readlines diceware_path
  5.times.map { word diceware }.join ' '
end

class Pinentry
  attr_reader :return_value

  def self.start &block
    pin = self.new &block
    pin.return_value
  end

  def initialize &block
    IO.popen('pinentry-curses', 'w+') do |subprocess|
      @subprocess = subprocess
      wait_for_ok

      request "OPTION ttyname=#{`tty`}"
      request "OPTION ttytype=#{ENV['TERM']}"
      request 'OPTION lc-ctype=en_US.UTF-8'

      @return_value = yield self

      @subprocess.close_write
    end
  end

  def prompt= message
    request "SETPROMPT #{message}"
  end

  def description= message
    request "SETDESC #{message}"
  end

  def generate
    request 'GETPIN'
  end

  def request command
    @subprocess.puts command
    wait_for_ok
  end

  def wait_for_ok
    response = @subprocess.readline.chomp 
    if response =~ /^(?:D |OK)(.*)/
      $1
    else
      raise "pinentry error: #{response}"
    end
  end
end

def retyped passphrase, remain
  Pinentry.start do |p|
    p.prompt = 'Passphrase:'
    p.description = "Please enter your passphrase #{remain} more times (#{passphrase})"
    p.generate == passphrase
  end
end

def tell_passphrase
  generate_passphrase.tap do |passphrase|
    loop do
      break if 3.times.map { |c| retyped passphrase, (3 - c) }.all?
    end
  end
end
