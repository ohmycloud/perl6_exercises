
use Bailador;
use Bailador::App;
use FindBin :vars;  # Gives us $Bin

class MyWebApp is Bailador::App {
    has Str $.tmpl_header;
    has Str $.tmpl_footer;

    submethod BUILD(|) {
        self.location = $Bin.IO.parent.Str;
        self.get: '/' => sub { self.send_template("index.tt") }
    }


    ### Bailador uses Template::Mojo by default.  But the p6 Template::Mojo is 
    ### not identical to the p5 version.  At the least, the p6 version does 
    ### not allow for layouts.
    ### 
    ### So I'm sort of replicating that by maintaining separate header and 
    ### footer templates that I'm wrapping around the requested template.
    ###
    ### It's not perfect, but it works.  And keeping $.tmpl_header and 
    ### $.tmpl_footer as attributes means that those templates don't have to 
    ### be re-parsed every time.
    method tmpl_header() {
        self.template: 'layouts/header.tt';
    }
    method tmpl_footer() {
        self.template: 'layouts/footer.tt';
    }
    method send_template(Str $tmpl) {
        $.tmpl_header ~ (self.template: $tmpl) ~ $.tmpl_footer;
    }


}
