describe 'Numeric extensions' do

  %w{
    pt
    mm
    in
    px
    dp
    dip
    sp
  }.each do |ext|
    it "should support ###.#{ext}" do
      [0, 1, 1.5].each do |num|
        expect(num.send(ext)).to eql("#{num}#{ext}")
      end
    end
  end

end
