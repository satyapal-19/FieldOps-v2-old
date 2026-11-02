/**
 * Session cookie names. All three are httpOnly: page scripts never see a token. The role
 * cookie only lets middleware route without calling the API; the API still checks the token.
 */
export const ACCESS_COOKIE = 'fo_at';
export const REFRESH_COOKIE = 'fo_rt';
export const ROLE_COOKIE = 'fo_role';
