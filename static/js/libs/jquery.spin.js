define('libs/jquery.spin', [
    'jquery',
    'libs/spin.min',
  ], 
  /**
   * jQuery Spinner plugin by Bradley Smith
   * 
   * @url https://gist.github.com/1290439
   */
  function($) {
    $.fn.spin = function(opts) {
      this.each(function() {
        var $this = $(this),
        data = $this.data();
        console.log(data);

        if (data.spinner) {
          data.spinner.stop();
          delete data.spinner;
        }
        if (opts !== false) {
          data.spinner = new Spinner(
            $.extend({color: $this.css('color')}, opts)
          ).spin(this);
        }
      });
      return this;
    };

    // DATA-API
    $(function () {
      $('[data-spin="spin"]').each(function () {
        var $spin = $(this);
        $spin.spin($spin.data());
      })
    })

  }
);

