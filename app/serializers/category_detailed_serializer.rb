class CategoryDetailedSerializer < BasicCategorySerializer

  attributes :topic_count,
             :post_count,
             :topics_day,
             :topics_week,
             :topics_month,
             :topics_year,
             :topics_all_time,
             :description_excerpt,
             :category_collapse_name,
             :category_expanding_class,
             :is_uncategorized,
             :subcategory_ids

  has_many :displayable_topics, serializer: ListableTopicSerializer, embed: :objects, key: :topics

  def include_displayable_topics?
    displayable_topics.present?
  end

  def is_uncategorized
    object.id == SiteSetting.uncategorized_category_id
  end

  def include_is_uncategorized?
    is_uncategorized
  end

  def description_excerpt
    PrettyText.excerpt(description, 300) if description
  end

  # Band-aid fix for category collapsing. CSD and CSP units are their own categories
  # but we want to hide them to consume less space in the front. So the CSP and CSD
  # category will get buttons to expand the the other categories
  def category_collapse_name
    if slug =~ /csp\d/
      'csp-collapsed'
    elsif slug =~ /csd\d/
      'csd-collapsed'
    elsif slug =~ /csf\w+/
      'csf-collapsed'
    end
  end

  def category_expanding_class
    if ['csd', 'csp', 'csf'].include? slug
      "#{slug}-collapsed"
    end
  end

  def include_subcategory_ids?
    subcategory_ids.present?
  end

  def topics_day
    count_with_subcategories(:topics_day)
  end

  def topics_week
    count_with_subcategories(:topics_week)
  end

  def topics_month
    count_with_subcategories(:topics_month)
  end

  def topics_year
    count_with_subcategories(:topics_year)
  end

  def topics_all_time
    count_with_subcategories(:topic_count)
  end

  def count_with_subcategories(method)
    count = object.send(method) || 0
    object.subcategories.each do |category|
      count += (category.send(method) || 0)
    end
    count
  end

end
