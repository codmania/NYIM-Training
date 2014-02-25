class Views::Assets::Select < Views::Assets::List

  def h1title
    params[:type]
  end

end