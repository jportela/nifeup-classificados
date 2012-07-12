require "open-uri"
prawn_document(:filename=> "#{@ad.title}.pdf",:page_size => "A4") do |pdf|
  pdf.text "#{I18n.t('generated')} FEUP Classificados"
  pdf.image "#{Rails.root}/app/assets/images/logo3.png", :position => :right,:vposition => :top
  pdf.text "#{@ad.title}", :size => 30, :style => :bold, :align => :center
  pdf.move_down(10)

  if @ad.thumbnail?
  	open('image.jpeg', 'wb') do |file|
  		file << open("http://#{request.env["HTTP_HOST"]}/classificados#{@ad.thumbnail.url(:medium)}").read
  	end

	pdf.image 'image.jpeg', :position => :center
    pdf.move_down(8)
  end

  if @ad.average_rate != nil
  	pdf.text "#{I18n.t('ad.average')}: #{@ad.average_rate}", :size => 12
	pdf.move_down(5)
  end

  if @ad.ad_tags.size > 0 
  	tags = "#{I18n.t('ad.keywords')}: "
		@ad.ad_tags.each do |t|
			if t != @ad.ad_tags.last then 
				tags << t.tag+", " 
			else 
				tags << t.tag 
			end
		end 
  	pdf.text tags, :size=>12
  	pdf.move_down(5)
  end

  pdf.text "#{I18n.t('ad.author')}: #{@ad.user.name} (#{@ad.user.username}@fe.up.pt)", :size => 12
  pdf.move_down(5)
  if @ad.description != ""
  	pdf.text "#{I18n.t('ad.description')}", :size => 12, :align => :justify
	pdf.move_down(5)
	pdf.indent(5) do
		pdf.text "#{@ad.description}"
	end
  end
end
