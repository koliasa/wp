// For Yoast SEO Plugin Version: 14.1+   add to your Wordpress Theme's functions.php...

// Remove All Yoast HTML Comments
// https://gist.github.com/paulcollett/4c81c4f6eb85334ba076
// Credit @devendrabhandari (https://gist.github.com/paulcollett/4c81c4f6eb85334ba076#gistcomment-3303423)
add_filter( 'wpseo_debug_markers', '__return_false' );



// For Yoast SEO Plugin Version: < 14.1   add to your Wordpress Theme's functions.php...

// Remove All Yoast HTML Comments
// https://gist.github.com/paulcollett/4c81c4f6eb85334ba076
// Credit @maxyudin (https://gist.github.com/paulcollett/4c81c4f6eb85334ba076#gistcomment-2937964)
add_action('wp_head',function() { ob_start(function($o) {
return preg_replace('/\n?<.*?yoast seo plugin.*?>/mi','',$o);
}); },~PHP_INT_MAX);