{% if page.series and page.series_order %}
  {% set currentSeries = page.series %}
  {% set currentOrder = page.series_order %}
  {% set seriesPosts = site.posts.find({series: currentSeries}).sort("series_order").toArray() %}
  
  <div class="series-nav" style="margin: 2rem 0; padding: 1rem; border: 1px solid #eee; border-radius: 8px;">
    <h4 style="margin: 0 0 1rem 0; font-size: 1.1rem;">《{{ page.series }}》系列导航</h4>
    <ul style="margin: 0; padding-left: 1.5rem; line-height: 1.8;">
      {% for post in seriesPosts %}
        <li {% if post.series_order == currentOrder %}style="color: #2196F3; font-weight: bold;"{% endif %}>
          {% if post.series_order == currentOrder %}
            第{{ post.series_order }}篇：{{ post.title }}（当前）
          {% else %}
            <a href="{{ post.url }}">第{{ post.series_order }}篇：{{ post.title }}</a>
          {% endif %}
        </li>
      {% endfor %}
    </ul>
  </div>
{% endif %}