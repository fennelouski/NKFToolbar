Summary
-------
NKFToolbar is a subclass of UIToolbar that is designed to easily add a vertical orientation to your toolbar.

Instructions
-------
Copy the `.h` and `.m` files into your project and then import the header file wherever you'd like to use NKFToolbar.

To change the layout to be vertical, set the `orientation` property to `NKFToolbarOrientationVertical`, set the frame appropriately, and then call`layoutSubviews`.

Notes
-------
NKFToolbar uses UIBarButtonItem in the vertical arrangement as well, so no need to use UIButton instead.
