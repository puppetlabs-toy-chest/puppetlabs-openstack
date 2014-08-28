ENV.each do |k,v|
  Facter.add("env_#{k.downcase}".to_sym) do
    setcode do
      v
    end
  end
end
