# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

b1 = Brewery.find_or_create_by(name: "Koff", year: 1897)
b2 = Brewery.find_or_create_by(name: "Malmgard", year: 2001)
b3 = Brewery.find_or_create_by(name: "Weihenstephaner", year: 1040)
s1 = Style.find_or_create_by(name: "Weizen") do |style|
  style.description = <<~DESC.gsub("\n", " ")
    Weizenbier of Hefeweizen is a beer, traditionally from Bavaria,
    in which a significant proportion of malter barley is replaced
    with malted wheat. The Hefeweizen style is particularly noted
    for its low hop bitterness and relatively high carbonation,
    considered important to balance the beer's relatively malty sweetness.
  DESC
end

s2 = Style.find_or_create_by(name: "Lager") do |style|
  style.description = <<~DESC.gsub("\n", " ")
    Lager is a style of beer brewed and conditioned at low temperature.
    Lagers can be pale, amber or dark. Pale lager is the most widely
    consumed and commercially available style of beer. As well as
    maturation in cold storage, most lagers are distinguished by the
    use of Saccharomyces pastorianus, a 'bottom-fermenting' yeast that
    ferments at relatively cold temperatures.
  DESC
end

s3 = Style.find_or_create_by(name: "Pale Ale") do |style|
  style.description = <<~DESC.gsub("\n", " ")
    Pale ale is a golden to amber coloured beer style brewed with pale malt.
    The term first appeared in England around 1703 for beers made from malts
    dried with high-carbon coke, which resulted in a lighter colour than other
    beers popular at that time. Different brewing practices and hop quantities
    have resulted in a range of tastes and strengths within the pale ale family.
    Pale ale is a kind of ale."
  DESC
end

s4 = Style.find_or_create_by(name: "IPA") do |style|
  style.description =  <<~DESC.gsub("\n", " ")
    India pale ale (IPA) is a hoppy beer style within the broader category of
    pale ale. It originated in the United Kingdom to be exported to India,
    which was under the control of the British East India Company until 1858.
    Its higher hop content acted as a natural preservative, preventing it from
    spoiling during the long shipping voyage. IPA has since regained significant
    popularity, and is associated with craft beer.
  DESC
end

s5 = Style.find_or_create_by(name:"Porter") do |style|
  style.description =  <<~DESC
    Porter is a style of beer that was developed in London in the early 18th
    century. It is well-hopped and dark in appearance owing to the use of brown
    malt. The name is believed to have originated from its popularity with porters.
    Porter became the first beer style brewed around the world, being produced in
    Ireland, North America, Sweden, and Russia by the end of the 18th century.
  DESC
end

s6 = Style.find_or_create_by(name: "Lowalcohol") do |style|
  style.description =  <<~DESC
    The demand for beers with low alcohol has been rising and many brewers offer
    a selection of low alcohol beers, representing different beer styles.
  DESC
end

b1.beers.create name: "Crisp Hoppy Lager", style_id: s6.id, brewery_id: b1.id
b1.beers.create name: "Brooklyn Summer Ale", style_id: s3.id, brewery_id: b1.id
b1.beers.create name: "Extra Light Triple Brewed", style_id: s2.id, brewery_id: b1.id
b2.beers.create name: "Huvila Pale Ale", style_id: s3.id, brewery_id: b2.id
b2.beers.create name: "X Porter", style_id: s5.id, brewery_id: b2.id
b2.beers.create name: "Hazy IPA", style_id: s4.id, brewery_id: b2.id
b3.beers.create name: "Hefeweizen", style_id: s1.id, brewery_id: b3.id
b3.beers.create name: "Helles", style_id: s2.id, brewery_id: b3.id
