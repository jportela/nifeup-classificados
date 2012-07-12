/* jqEasy drop down sign in form
 * Examples and documentation at: http://www.jqeasy.com/
 * Version: 1.0 (22/03/2010)
 * No license. Use it however you want. Just keep this notice included.
 * Requires: jQuery v1.3+
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
 
   
  // login actions
$(document).ready(function() {
    $('.btnsignin').click(function(e) {
		e.preventDefault();
		$("#frmsignin").toggle('fast',function() {
				$('#username').focus();
			});
		$(this).toggleClass("btnsigninon");
		$('#msg').empty();
	});
	
	$('.btnsignin').mouseup(function() {
		return false;
	});
	
	$(document).mouseup(function(e) {
		if($(e.target).parents('#frmsignin').length==0) {
			$('.btnsignin').removeClass('btnsigninon');
			$('#frmsignin').hide('fast');
		};
	});
	
	$('#signin').ajaxForm({
		beforeSubmit: validate,
		success: function(data) {
			if (data=='OK') {
				$('#frmsignin').text('Signed in!');
				$('#frmsignin').delay(800).fadeOut(400);
			} else {
				$('#msg').html(data);
				$('#username').focus();
			}
		}
	});
});

function validate(formData, jqForm, options) { 
	var form = jqForm[0];
	var un = $.trim(form.username.value);
	var pw = $.trim(form.password.value);
	var unReg = /^[A-Za-z0-9_]{3,20}$/;
	var pwReg = /^[A-Za-z0-9!@#$%&*()_]{6,20}$/;
	var hasError = false;
	var errmsg = '';
	
	if (!un) { 
		errmsg = '<p>Please enter a username</p>';
		hasError = true;
	} else if(!unReg.test(un)) {
		errmsg = '<p>Username must be 3 - 20 characters (a-z, 0-9, _).</p>';
		hasError = true;
	}
	
	if (!pw) { 
		errmsg += '<p>Please enter a password</p>';
		hasError = true;
	} else if(!pwReg.test(pw)) {
		errmsg += '<p>Password must be 6 - 20 characters (a-z, 0-9, !, @, #, $, %, &, *, (, ), _).</p>';
		hasError = true;
	}
	
	if (!hasError) {
		$('#msg').html('<p><img src="loading.gif" alt="loading" /> signing in...</p>');
	} else {
		$('#msg').html(errmsg);
	return false;
	}
}
