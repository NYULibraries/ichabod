class NyucorePresenter

  attr_reader :nyucore

  def initialize(nyucore)
    unless nyucore.is_a?(Nyucore)
      raise ArgumentError.new("Expecting #{nyucore} to be an Nyucore")
    end
    @nyucore = nyucore
  end

  def values(field)
    nyucore.send(field)
  end

  def editable?(field, value)
    !source?(field, value)
  end

  def source?(field, value)
    nyucore.source_metadata.send(field).include?(value)
  end

  def multiple?(field)
    Nyucore.multiple?(field)
  end
end
