function c = component(~, ~) %#ok<*STOUT>
% Private function to extract the numerical value of the nth component of
% the multivector m. Returns an appropriate array of zeros if that
% component is empty, but empty if the whole multivector is empty.

% TODO This function is obsolescent. The PART function does the same thing
% with a direct call to GET. When all the callers of this function have
% been edited to use GET or PART, this function can be removed from the
% toolbox.

% Copyright © 2015 Stephen J. Sangwine and Eckhard Hitzer
% See the file : Copyright.m for further details.

error('Obsolescent private function COMPONENT called.')

% c = get(m, n);
% if ~isempty(c), return, end
% 
% % The component we have been asked to return is empty. Now we are forced to
% % test the whole multivector in order to return empty if all components are
% % empty, but a zero array of the correct size and class if not.
% 
% if ~isempty(m)
%     c = zeros(size(m), class(c));
% else
%     c = cast([], class(c));
% end

end

% $Id: component.m 271 2021-07-11 19:54:47Z sangwine $
