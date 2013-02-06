dep 'locale' do
  requires 'generated.locale'
  requires 'configuration.locale'
end

meta 'render' do
  accepts_value_for :source
  accepts_value_for :target

  template {
    def template
      dependency.load_path.parent / source
    end

    met? { Babushka::Renderable.new(target).from?(template) }
    meet { render_erb template, :to => target }
  }
end

dep 'generated.locale', :template => 'render' do
  source 'locale.gen.erb'
  target '/etc/locale.gen'
end

dep 'configuration.locale', :template => 'render' do
  source 'locale.conf.erb'
  target '/etc/locale.conf'
end
