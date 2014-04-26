class Temperature

  # * +t+ - temperature in F
  # * +a+ - air speed in mph
  def self.wind_chill(t, a)
    c1 = 35.74
    c2 = 0.6215
    c3 = 35.75
    c4 = 0.16
    c5 = 0.4275
    c1 + c2*t -c3*a**c4 + c5*t*a**c4
  end

  # * +t+ - temperature in F
  # * +r+ - relative humidity
  def self.heat_index(t, r)
    # Input = 0.4, calculation = 40%
    if r <= 1
      r = r*100
    end

    c1 = -42.379
    c2 = 2.04901523
    c3 = 10.14333127
    c4 = -0.22475541
    c5 = -6.83783*10**-3
    c6 = -5.481717*10**-2
    c7 = 1.22874*10**-3
    c8 = 8.5282*10**-4
    c9 = -1.99*10**-6
    heat_index = c1 + c2*t + c3*r + c4*t*r + c5*t**2 + c6*r**2 + c7*t**2*r +\
      c8*t*r**2 + c9*t**2*r**2
  end

  # * +t+ - temperature in F
  # * +a+ - air speed in mph
  # * +r+ - relative humidity
  def self.apparent_temperature(t, a, r)
    if t >= 80 and r >= 0.4
      return self.heat_index(t, r)
    end

    if t <= 40 and a >= 3
      return self.wind_chill(t, a)
    end

    return t
  end
end
